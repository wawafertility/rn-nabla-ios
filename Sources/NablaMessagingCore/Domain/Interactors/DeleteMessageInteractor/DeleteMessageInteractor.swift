import Foundation
import W_NablaCore

protocol DeleteMessageInteractor {
    /// - Throws: ``NablaError``
    func execute(messageId: UUID, conversationId: UUID) async throws
}
