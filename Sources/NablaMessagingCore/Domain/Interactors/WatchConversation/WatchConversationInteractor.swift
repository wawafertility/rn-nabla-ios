import Combine
import Foundation
import NablaCoreFork

protocol WatchConversationInteractor {
    func execute(_ conversationId: UUID) -> AnyPublisher<Response<Conversation>, NablaError>
}
