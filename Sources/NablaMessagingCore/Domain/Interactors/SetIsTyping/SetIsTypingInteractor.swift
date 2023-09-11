import Foundation
import NablaCoreFork

protocol SetIsTypingInteractor {
    /// - Throws: ``NablaError``
    func execute(isTyping: Bool, conversationId: UUID) async throws
}
