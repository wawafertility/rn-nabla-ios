import Foundation
import NablaMessagingCoreFork

public protocol ConversationListDelegate: AnyObject {
    func conversationList(didSelect conversation: Conversation)
}
