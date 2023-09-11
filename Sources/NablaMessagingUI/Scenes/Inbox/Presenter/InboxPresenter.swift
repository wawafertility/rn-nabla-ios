import Foundation
import NablaMessagingCoreFork

// sourcery: AutoMockable
protocol InboxPresenter: Presenter {
    @MainActor func userDidTapCreateConversation()
    @MainActor func userDidSelectConversation(_ conversation: Conversation)
}
