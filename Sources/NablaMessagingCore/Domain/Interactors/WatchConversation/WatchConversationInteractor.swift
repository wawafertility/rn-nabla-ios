import Combine
import Foundation
import W_NablaCore

protocol WatchConversationInteractor {
    func execute(_ conversationId: UUID) -> AnyPublisher<Response<Conversation>, NablaError>
}
