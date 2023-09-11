import Foundation
import NablaCoreFork

protocol SendMessageInteractor {
    /// - Throws: ``NablaError``
    func execute(
        message: MessageInput,
        replyToMessageId: UUID?,
        conversationId: UUID
    ) async throws
}
