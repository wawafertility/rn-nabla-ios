import Foundation
import NablaMessagingCoreFork

struct ImageMessageViewItem: ConversationViewMessageItem {
    let id: UUID
    let date: Date
    let sender: NablaMessagingCoreFork.ConversationMessageSender
    let sendingState: ConversationMessageSendingState
    let replyTo: ConversationViewMessageItem?
    let image: ImageFile
    var isContiguous: Bool = false
    var isFocused: Bool = false
}

extension ImageMessageViewItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(sender)
        hasher.combine(sendingState)
        hasher.combine(image)
        hasher.combine(isContiguous)
        hasher.combine(isFocused)
    }

    static func == (lhs: ImageMessageViewItem, rhs: ImageMessageViewItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
