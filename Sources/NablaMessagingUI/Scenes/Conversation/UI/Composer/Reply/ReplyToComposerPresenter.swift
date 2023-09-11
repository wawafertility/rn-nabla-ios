import Foundation
import NablaMessagingCoreFork

protocol ReplyToComposerPresenterDelegate: AnyObject {
    func replyToComposerPresenterDidTapCloseButton(_ presenter: ReplyToComposerPresenter)
}

protocol ReplyToComposerPresenter: Presenter {
    func didUpdate(message: ConversationViewMessageItem?)
    func didTapCloseButton()
}
