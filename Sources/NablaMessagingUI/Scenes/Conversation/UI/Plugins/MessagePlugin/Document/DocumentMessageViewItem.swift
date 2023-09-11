import Foundation
import NablaMessagingCoreFork

struct DocumentMessageViewItem: ConversationViewMessageItem {
    let id: UUID
    let date: Date
    let sender: NablaMessagingCoreFork.ConversationMessageSender
    let sendingState: ConversationMessageSendingState
    let replyTo: ConversationViewMessageItem?
    let document: DocumentFile
    var isContiguous: Bool = false
    var isFocused: Bool = false
}

extension DocumentMessageViewItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(sender)
        hasher.combine(sendingState)
        hasher.combine(document)
        hasher.combine(isContiguous)
        hasher.combine(isFocused)
    }

    static func == (lhs: DocumentMessageViewItem, rhs: DocumentMessageViewItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
