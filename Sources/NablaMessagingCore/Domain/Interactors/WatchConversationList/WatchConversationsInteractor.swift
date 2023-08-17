import Combine
import Foundation
import W_NablaCore

protocol WatchConversationsInteractor {
    func execute() -> AnyPublisher<Response<PaginatedList<Conversation>>, NablaError>
}
