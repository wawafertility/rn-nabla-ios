import Foundation
import NablaCoreFork
import NablaMessagingCoreFork

final class DocumentMessagePresenter:
    MessagePresenter<
        DocumentMessageContentView,
        DocumentMessageViewItem,
        ConversationMessageCell<DocumentMessageContentView>
    > {
    // MARK: - Init
        
    init(
        logger: Logger,
        item: DocumentMessageViewItem,
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
            transformContent: DocumentMessageContentViewModelTransformer.transform
        )
    }
    
    override func userDidTapContent() {
        delegate?.didTap(document: item.document)
    }
}
