import Foundation
import NablaCoreFork
import NablaMessagingCoreFork

final class ImageMessagePresenter:
    MessagePresenter<
        ImageMessageContentView,
        ImageMessageViewItem,
        ConversationMessageCell<ImageMessageContentView>
    > {
    // MARK: - Init
    
    init(
        logger: Logger,
        item: ImageMessageViewItem,
        conversationId: UUID,
        client: NablaMessagingClientProtocol,
        delegate: ConversationCellPresenterDelegate
    ) {
        super.init(
            logger: logger,
            item: item,
            conversationId: conversationId,
            client: client,
            delegate: delegate,
            transformContent: ImageMessageContentViewModelTransformer.transform
        )
    }
    
    override func userDidTapContent() {
        delegate?.didTap(image: item.image)
    }
}
