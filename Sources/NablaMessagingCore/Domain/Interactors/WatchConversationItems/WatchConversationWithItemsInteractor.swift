import Combine
import Foundation
import W_NablaCore

protocol WatchConversationItemsInteractor {
    func execute(conversationId: UUID) -> AnyPublisher<Response<PaginatedList<ConversationItem>>, NablaError>
}
