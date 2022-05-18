import Foundation
import NablaUtils

class ConversationRepositoryImpl: ConversationRepository {
    // MARK: - Initializer

    init(remoteDataSource: ConversationRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    // MARK: - Internal
    
    func watchConversation(
        _ conversationId: UUID,
        handler: ResultHandler<Conversation, NablaError>
    ) -> Cancellable {
        let watcher = remoteDataSource.watchConversation(
            conversationId,
            handler: .init { [weak self] result in
                switch result {
                case let .failure(error):
                    handler(.failure(GQLErrorTransformer.transform(gqlError: error)))
                case let .success(data):
                    let conversation = ConversationTransformer.transform(fragment: data)
                    if conversation.providers.contains(where: \.isTyping) {
                        self?.remoteTypingDebouncer.execute {
                            handler(.success(conversation))
                        }
                    } else {
                        self?.remoteTypingDebouncer.cancel()
                    }
                    handler(.success(conversation))
                }
            }
        )

        return watcher
    }
    
    func watchConversations(handler: ResultHandler<ConversationList, NablaError>) -> PaginatedWatcher {
        let watcher = remoteDataSource.watchConversations(handler: .init { result in
            switch result {
            case let .failure(error):
                handler(.failure(GQLErrorTransformer.transform(gqlError: error)))
            case let .success(data):
                let model = ConversationList(
                    conversations: ConversationTransformer.transform(data: data),
                    hasMore: data.conversations.hasMore
                )
                handler(.success(model))
            }
        })

        let holder = PaginatedWatcherAndSubscriptionHolder(watcher: watcher)
        
        let eventsSubscription = makeOrReuseConversationEventsSubscription()
        holder.hold(eventsSubscription)
        
        return watcher
    }
    
    func createConversation(handler: ResultHandler<Conversation, NablaError>) -> Cancellable {
        remoteDataSource.createConversation(
            handler: handler
                .pullbackError(GQLErrorTransformer.transform)
                .pullback(ConversationTransformer.transform)
        )
    }
    
    // MARK: - Private
    
    private let remoteDataSource: ConversationRemoteDataSource

    private weak var conversationsEventsSubscription: Cancellable?
    private let remoteTypingDebouncer: Debouncer = .init(
        delay: ProviderInConversation.Constants.typingTimeWindowTimeInterval,
        queue: .global(qos: .userInitiated)
    )
    
    private func makeOrReuseConversationEventsSubscription() -> Cancellable {
        if let subscription = conversationsEventsSubscription {
            return subscription
        }
        
        let subscription = remoteDataSource.subscribeToConversationsEvents(handler: .void)
        conversationsEventsSubscription = subscription
        return subscription
    }
}
