import Foundation
import NablaCoreFork

protocol MarkConversationAsSeenInteractor {
    /// - Throws: ``NablaError``
    func execute(conversationId: UUID) async throws
}
