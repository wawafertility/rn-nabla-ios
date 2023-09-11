import AVKit
import Foundation
import NablaCoreFork
import NablaMessagingCoreFork
import UIKit

protocol MediaComposerCollectionViewCellDelegate: AnyObject {
    func mediaComposerCollectionViewCellDidTapDeleteButton(_ cell: MediaComposerCollectionViewCell)
}

class MediaComposerCollectionViewCell: UICollectionViewCell, Reusable {
    weak var delegate: MediaComposerCollectionViewCellDelegate?
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    func configure(with viewModel: MediaComposerItemViewModel) throws {
        switch viewModel.type {
        case let .image(source):
            // Here
            imageView.source = source
            setVisibleView(imageView)
        case .pdf:
            imageView.image = NablaTheme.Conversation.mediaComposerDocumentIcon
            setVisibleView(imageView)
        case let .video(source):
            try playerView.setMediaSource(mediaSource: source)
            setVisibleView(playerView)
        }
    }
    
    // MARK: Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.source = nil
    }
    
    // MARK: - Private
    
    private lazy var imageView: NablaViews.ImageView = makeImageView()
    private lazy var playerView: UIPlayerView = makePlayerView()
    private lazy var deleteButton: UIButton = makeDeleteButton()
    private lazy var deleteButtonContainerView: UIView = makeDeleteButtonContainerView()

    private func setUp() {
        guard contentView.subviews.isEmpty else { return }
        contentView.isUserInteractionEnabled = false
        contentView.backgroundColor = NablaTheme.Conversation.mediaComposerBackgroundColor

        addSubview(imageView)
        imageView.nabla.pinToSuperView()

        addSubview(playerView)
        playerView.nabla.pinToSuperView()

        addSubview(deleteButtonContainerView)
        deleteButtonContainerView.nabla.pinToSuperView(edges: [.top, .trailing], insets: .nabla.make(horizontal: 5, vertical: 5))

        layer.cornerRadius = 10.0
        clipsToBounds = true
    }
    
    private func makeImageView() -> NablaViews.ImageView {
        let view = NablaViews.ImageView()
        view.tintColor = NablaTheme.Conversation.mediaComposerDocumentTintColor
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }

    private func makePlayerView() -> UIPlayerView {
        let view = UIPlayerView()
        return view
    }
    
    private func makeDeleteButton() -> UIButton {
        let button = UIButton()
        button.setImage(NablaTheme.Conversation.mediaComposerDeleteButtonIcon, for: .normal)
        button.tintColor = NablaTheme.Conversation.mediaComposerDeleteButtonTintColor
        button.addTarget(self, action: #selector(deleteButtonSelected), for: .touchUpInside)
        return button
    }
    
    private func makeDeleteButtonContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = NablaTheme.Conversation.mediaComposerDeleteButtonBackgroundColor
        view.addSubview(deleteButton)
        deleteButton.nabla.pinToSuperView()
        view.nabla.constraintToSize(.init(width: 15, height: 15))
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }
    
    @objc private func deleteButtonSelected() {
        delegate?.mediaComposerCollectionViewCellDidTapDeleteButton(self)
    }

    private func setVisibleView(_ visibleView: UIView) {
        // Only add views whose visibility might change.
        [
            imageView,
            playerView,
        ]
        .forEach { $0.isHidden = $0 != visibleView }
    }
}
