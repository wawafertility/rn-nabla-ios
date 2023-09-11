import Foundation
import NablaCoreFork
import NablaMessagingCoreFork
import UIKit

final class TypingIndicatorCellProvider: ConversationCellProvider {
    // MARK: - Internal
    
    func prepare(collectionView: UICollectionView) {
        collectionView.nabla.register(Cell.self)
    }
    
    func provideCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: ConversationViewItem,
        viewController _: UIViewController?,
        delegate: ConversationCellPresenterDelegate
    ) -> UICollectionViewCell? {
        guard let item = item as? TypingIndicatorViewItem else {
            return nil
        }
        
        let cell = collectionView.nabla.dequeueReusableCell(ofClass: Cell.self, for: indexPath)
        let presenter = findOrCreatePresenter(
            item: item,
            delegate: delegate
        )
        presenter.attachView(cell)
        cell.configure(presenter: presenter)
        return cell
    }
    
    init(
        logger: Logger,
        conversationId: UUID,
        client: NablaMessagingClientProtocol
    ) {
        self.logger = logger
        self.conversationId = conversationId
        self.client = client
    }
    
    // MARK: - Private
    
    private typealias Cell = ConversationMessageCell<TypingIndicatorContentView>

    private let logger: Logger
    private let client: NablaMessagingClientProtocol
    private let conversationId: UUID
    private var presenters: [UUID: TypingIndicatorPresenter] = [:]
    
    private func findOrCreatePresenter(
        item: TypingIndicatorViewItem,
        delegate: ConversationCellPresenterDelegate
    ) -> TypingIndicatorPresenter {
        if let presenter = presenters[item.id] {
            presenter.item = item
            return presenter
        } else {
            let presenter = TypingIndicatorPresenter(
                logger: logger,
                item: item,
                conversationId: conversationId,
                client: client,
                delegate: delegate
            )
            presenters[item.id] = presenter
            return presenter
        }
    }
}
