import Foundation
import W_NablaCore

protocol SetIsTypingInteractor {
    /// - Throws: ``NablaError``
    func execute(isTyping: Bool, conversationId: UUID) async throws
}
