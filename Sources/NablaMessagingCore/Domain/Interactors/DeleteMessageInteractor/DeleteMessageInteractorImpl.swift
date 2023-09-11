import Foundation
import NablaCore

final class DeleteMessageInteractorImpl: AuthenticatedInteractor, DeleteMessageInteractor {
    // MARK: - Initializer

    init(
        userRepository: UserRepository,
        itemsRepository: ConversationItemRepository,
        conversationsRepository: ConversationRepository
    ) {
        self.itemsRepository = itemsRepository
        self.conversationsRepository = conversationsRepository
        super.init(userRepository: userRepository)
    }

    // MARK: - DeleteMessageInteractor
    
    /// - Throws: ``NablaError``
    func execute(messageId: UUID, conversationId: UUID) async throws {
        try assertIsAuthenticated()
        let transientId = conversationsRepository.getConversationTransientId(from: conversationId)
        try await itemsRepository.deleteMessage(withId: messageId, conversationId: transientId)
    }
    
    // MARK: - Private
    
    private let itemsRepository: ConversationItemRepository
    private let conversationsRepository: ConversationRepository
}
