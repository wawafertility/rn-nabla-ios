import Combine
import Foundation
import NablaCoreFork

protocol WatchConversationItemsInteractor {
    func execute(conversationId: UUID) -> AnyPublisher<Response<PaginatedList<ConversationItem>>, NablaError>
}
