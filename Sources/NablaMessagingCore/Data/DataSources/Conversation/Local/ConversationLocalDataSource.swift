import Combine
import Foundation
import NablaCoreFork

// sourcery: AutoMockable
protocol ConversationLocalDataSource {
    func getConversation(withId id: UUID) -> LocalConversation?
    
    func startConversation(title: String?, providerIds: [UUID]?) -> LocalConversation
    
    func updateConversation(_ conversation: LocalConversation)
    
    func watchConversation(_ conversationId: UUID) -> AnyPublisher<LocalConversation?, Never>
}
