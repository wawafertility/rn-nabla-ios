import Foundation
import W_NablaCore

protocol MarkConversationAsSeenInteractor {
    /// - Throws: ``NablaError``
    func execute(conversationId: UUID) async throws
}
