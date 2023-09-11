import Foundation
import NablaCoreFork
import NablaMessagingCoreFork
import UIKit

final class AudioMessageCellProvider: ConversationCellProvider {
    // MARK: Initializer
    
    init(
        logger: Logger,
        conversationId: UUID,
        client: NablaMessagingClientProtocol
    ) {
        self.logger = logger
        self.conversationId = conversationId
        self.client = client
    }
    
    // MARK: - Public
    
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
        guard let item = item as? AudioMessageViewItem else {
            return nil
        }
        
        let cell = collectionView.nabla.dequeueReusableCell(ofClass: Cell.self, for: indexPath)
        let presenter = findOrCreatePresenter(
            item: item,
            delegate: delegate
        )
        presenter.attachView(cell)
        cell.configure(presenter: presenter)
        cell.content.delegate = presenter
        return cell
    }
    
    // MARK: - Private
    
    private typealias Cell = ConversationMessageCell<AudioMessageContentView>
    
    private let client: NablaMessagingClientProtocol
    private let logger: Logger
    private let conversationId: UUID
    
    private var presenters: [UUID: AudioMessagePresenter] = [:]
    
    private func findOrCreatePresenter(
        item: AudioMessageViewItem,
        delegate: ConversationCellPresenterDelegate
    ) -> AudioMessagePresenter {
        if let presenter = presenters[item.id] {
            presenter.item = item
            return presenter
        } else {
            let presenter = AudioMessagePresenter(
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
