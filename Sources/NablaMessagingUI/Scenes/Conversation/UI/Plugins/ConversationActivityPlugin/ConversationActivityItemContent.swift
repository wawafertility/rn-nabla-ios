import Foundation
import NablaMessagingCoreFork

struct ConversationActivityViewItem: ConversationViewItem, Hashable {
    let id: UUID
    let date: Date
    let activity: ConversationActivity.Content
}
