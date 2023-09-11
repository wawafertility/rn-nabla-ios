import Foundation
import NablaMessagingCoreFork

struct VideoMessageViewItem: ConversationViewMessageItem {
    let id: UUID
    let date: Date
    let sender: NablaMessagingCoreFork.ConversationMessageSender
    let sendingState: ConversationMessageSendingState
    let replyTo: ConversationViewMessageItem?
    let video: VideoFile
    var isContiguous: Bool = false
    var isFocused: Bool = false
}

extension VideoMessageViewItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(sender)
        hasher.combine(sendingState)
        hasher.combine(video)
        hasher.combine(isContiguous)
        hasher.combine(isFocused)
    }

    static func == (lhs: VideoMessageViewItem, rhs: VideoMessageViewItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
