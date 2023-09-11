import Foundation
import NablaCoreFork

protocol RetrySendingMessageInteractor {
    /// - Throws: ``NablaError``
    func execute(
        itemId: UUID,
        conversationId: UUID
    ) async throws
}
