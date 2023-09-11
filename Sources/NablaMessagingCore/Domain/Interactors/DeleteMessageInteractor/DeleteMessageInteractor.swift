import Foundation
import NablaCoreFork

protocol DeleteMessageInteractor {
    /// - Throws: ``NablaError``
    func execute(messageId: UUID, conversationId: UUID) async throws
}
