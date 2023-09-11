import Combine
import Foundation
import NablaCoreFork

protocol WatchConversationsInteractor {
    func execute() -> AnyPublisher<Response<PaginatedList<Conversation>>, NablaError>
}
