import Foundation
import NablaCoreFork
import NablaMessagingCoreFork

struct ConversationListViewModelTransformer {
    // MARK: - Public
    
    func transform(conversation: Conversation) -> ConversationListItemViewModel {
        ConversationListItemViewModel(
            id: conversation.id,
            avatar: AvatarViewModelTransformer.avatar(for: conversation),
            title: conversation.inboxPreviewTitle,
            subtitle: conversation.lastMessagePreview ?? conversation.subtitle,
            lastUpdatedTime: lastUpdatedTime(from: conversation),
            isUnread: conversation.patientUnreadMessageCount > 0
        )
    }
    
    // MARK: - Private
    
    private var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("E")
        return formatter
    }()
    
    private var dateInYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MM/dd")
        return formatter
    }()
    
    private var dateLongAgoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func lastUpdatedTime(from conversation: Conversation) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(conversation.lastModified) {
            return timeFormatter.string(from: conversation.lastModified)
        } else if calendar.isDateInYesterday(conversation.lastModified) {
            return L10n.conversationListLastMessageYesterday
        } else if calendar.isDateInWeek(conversation.lastModified) {
            return shortDateFormatter.string(from: conversation.lastModified)
        } else if calendar.isDateInYear(conversation.lastModified) {
            return dateInYearFormatter.string(from: conversation.lastModified)
        } else {
            return dateLongAgoFormatter.string(from: conversation.lastModified)
        }
    }
}
