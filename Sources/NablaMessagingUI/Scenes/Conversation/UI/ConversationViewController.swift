import Foundation
import NablaCoreFork
import NablaDocumentScannerFork
import NablaMessagingCoreFork
import PDFKit
import UIKit

final class ConversationViewController: UIViewController, ConversationViewContract {
    // MARK: - Internal
    
    var presenter: ConversationPresenter!
    
    weak var delegate: ConversationViewControllerDelegate?
    
    // MARK: Init

    init(
        logger: Logger,
        videoCallClient: VideoCallClient?,
        providers: [ConversationCellProvider],
        delegate: ConversationViewControllerDelegate?
    ) {
        self.logger = logger
        self.providers = providers
        self.videoCallClient = videoCallClient
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.start()
    }

    // MARK: ConversationViewContract

    var showRecordAudioMessageButton = true {
        didSet { composerView.showRecordAudioButton = showRecordAudioMessageButton }
    }

    func configure(withConversation conversation: ConversationViewModel) {
        titleView.title = conversation.title
        titleView.avatar = conversation.avatar
        titleView.subtitle = conversation.subtitle
    }

    func configure(withState state: ConversationViewState) {
        self.state = state
    }

    func emptyComposer() {
        composerView.emptyComposer()
    }

    func displayMediaPicker(source: ImagePickerSource) {
        let picker = imagePickerModule.makeViewController(
            source: source,
            mediaTypes: [.image, .video]
        )
        present(picker, animated: true)
    }

    func displayImageDetail(for image: ImageFile) {
        let viewController = ImageDetailViewController()

        let presenter = ImageDetailPresenterImpl(viewContract: viewController, image: image)
        viewController.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController).nabla.withOpaqueNavigationBarBackground()
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true)
    }

    func displayDocumentDetail(for document: DocumentFile) {
        let viewController = DocumentDetailViewController()
        
        let presenter = DocumentDetailPresenterImpl(viewContract: viewController, document: document)
        viewController.presenter = presenter

        let navigationController = UINavigationController(rootViewController: viewController).nabla.withOpaqueNavigationBarBackground()
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
    
    func displayDocumentScanner() {
        present(DocumentScannerModule.makeViewController(delegate: self), animated: true)
    }

    @available(iOS 14, *)
    func displayDocumentPicker() {
        let picker = DocumentPickerModule.makeViewController(delegate: self)
        present(picker, animated: true)
    }
    
    func displayVideoCallRoom(url: String, token: String) {
        guard let client = videoCallClient else {
            logger.error(message: "Trying to open some video call but the NablaVideoCallModule is missing.")
            return
        }
        client.openVideoCallRoom(url: url, token: token, from: self)
    }

    func showErrorAlert(viewModel: AlertViewModel) {
        present(
            UIAlertController.create(with: viewModel),
            animated: true
        )
    }

    func set(replyToMessage: ConversationViewMessageItem) {
        composerView.replyToMessage = replyToMessage
    }

    func scrollToItem(withId id: UUID) {
        guard
            case let .loaded(items, _, _) = state,
            let item = items.first(where: { $0.id == id }),
            let indexPath = dataSource.indexPath(for: DiffableConversationViewItem(value: item)) else {
            return
        }
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }

    // MARK: - Private

    private enum Section {
        case main
    }

    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiffableConversationViewItem>

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, DiffableConversationViewItem>

    private let logger: Logger
    private let providers: [ConversationCellProvider]
    private let videoCallClient: VideoCallClient?
    
    private var state: ConversationViewState = .loading {
        didSet {
            updateLayoutAfterStateChange(oldValue: oldValue)
        }
    }
    
    private lazy var dataSource = makeDataSource()
    
    private lazy var titleView: TitleView = makeTitleView()
    
    private let loadingView: LoadingView = .init()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.delegate = self
        return view
    }()
    
    private let loadedView: UIView = .init()
    private var loadedViewBottomConstraint: NSLayoutConstraint?

    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var composerView: ComposerView = makeComposerView()
    
    private lazy var refreshingIndicatorItem: UIBarButtonItem = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.color = NablaTheme.Colors.Stroke.base
        return UIBarButtonItem(customView: view)
    }()
    
    // TODO: @tgy - Don't retain modules
    private lazy var imagePickerModule = ImagePickerModule(delegate: self)
    
    private lazy var tapGesture: UIGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        recognizer.cancelsTouchesInView = false
        return recognizer
    }()
    
    @objc private func tapGestureHandler() {
        view.endEditing(true)
    }
    
    private func initialize() {
        hidesBottomBarWhenPushed = true
        
        navigationItem.titleView = navigationItem.titleView ?? titleView
        navigationItem.largeTitleDisplayMode = .never
        
        let scrollEdgeAppearance = navigationItem.scrollEdgeAppearance
            ?? UINavigationBar.appearance().scrollEdgeAppearance?.copy()
            ?? UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithDefaultBackground()
        navigationItem.scrollEdgeAppearance = scrollEdgeAppearance
        
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    private func setUp() {
        // The background of the chat is set on the `collectionView`.
        // We use the `composerBackgroundColor` here because of safe area, `self.view` is visble under the composer.
        view.backgroundColor = NablaTheme.Conversation.composerBackgroundColor
    }
    
    private func makeTitleView() -> TitleView {
        let view = TitleView(frame: .zero)
        view.isEnabled = delegate?.conversationViewControllerShouldEnableTapOnTitleView(self) ?? false
        view.onTap = { [weak self] in
            guard let self = self else { return }
            self.delegate?.conversationViewControllerDidTapTitleView(self)
        }
        return view
    }
    
    private func makeComposerView() -> ComposerView {
        let composerView = ComposerView(dependencies: .init(logger: logger))
        composerView.placeHolder = L10n.conversationComposerPlaceholder
        composerView.delegate = self
        return composerView
    }
    
    private func makeCollectionView() -> UICollectionView {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group: NSCollectionLayoutGroup = .vertical(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = FlippedCollectionViewCompositionalLayout(section: section)
        let collectionView = FlippedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.keyboardDismissMode = .interactive
        collectionView.delegate = self
        collectionView.backgroundColor = NablaTheme.Conversation.backgroundColor
        providers.forEach { $0.prepare(collectionView: collectionView) }
        collectionView.nabla.register(InvisibleCell.self)
        return collectionView
    }
    
    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
            self.provideCell(collectionView: collectionView, indexPath: indexPath, item: item.value)
        }
    }
    
    private func provideCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: ConversationViewItem
    ) -> UICollectionViewCell {
        for provider in providers { // TODO: @ams Switch to [type:plugin] dictionary
            if let cell = provider.provideCell(
                collectionView: collectionView,
                indexPath: indexPath,
                item: item,
                viewController: self,
                delegate: self
            ) {
                return cell
            }
        }
        let message = "No plugin provided a cell for item"
        logger.error(message: message, extra: ["type": type(of: item)])
        assertionFailure(message)
        return collectionView.nabla.dequeueReusableCell(ofClass: InvisibleCell.self, for: indexPath)
    }
    
    // The view controller has 3 possible layouts
    //
    // - Error -> errorView
    // - Loading -> loadingView
    // - Loaded -> collectionView + composerView
    private func updateLayoutAfterStateChange(oldValue: ConversationViewState) {
        switch (state, oldValue) {
        case let (.loaded(items, showComposer, isRefreshing), .loaded(previousItems, _, _)):
            applySnapshot(items: items, animatingDifferences: !previousItems.isEmpty)
            updateComposerVisibility(showComposer: showComposer)
            set(refreshing: isRefreshing)
        case (.loading, _):
            switchToLoadingLayout()
            loadingView.startAnimating()
        case let (.error(viewModel), _):
            switchToErrorLayout(viewModel: viewModel)
        case let (.loaded(items, showComposer, isRefreshing), _):
            switchToLoadedLayout(with: collectionView)
            updateComposerVisibility(showComposer: showComposer)
            applySnapshot(items: items)
            set(refreshing: isRefreshing)
        }
    }
    
    private func switchToLoadingLayout() {
        view.nabla.removeSubviews()
        view.addSubview(loadingView)
        loadingView.nabla.pinToSuperView()
    }
    
    private func switchToErrorLayout(viewModel: ErrorViewModel) {
        view.nabla.removeSubviews()
        view.addSubview(errorView)
        errorView.nabla.pinToSuperView()
        errorView.configure(with: viewModel)
    }
    
    private func switchToLoadedLayout(with containedView: UIView) {
        view.nabla.removeSubviews()
        view.addSubview(loadedView)
        loadedView.addSubview(containedView)
        loadedView.nabla.pinToSuperView(edges: .nabla.horizontal)
        containedView.nabla.pinToSuperView()

        loadedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    private func switchLoadedLayout(from fromView: UIView, to toView: UIView) {
        fromView.removeFromSuperview()
        loadedView.addSubview(toView)
        toView.nabla.pinToSuperView()
    }
    
    private func set(refreshing: Bool) {
        if refreshing {
            navigationItem.nabla.insertRightBarButtonItem(refreshingIndicatorItem, at: 0)
        } else {
            navigationItem.nabla.removeRightBarButtonItem(refreshingIndicatorItem)
        }
    }
    
    private func applySnapshot(items: [ConversationViewItem], animatingDifferences: Bool = true) {
        var seen = Set<UUID>()
        let items = items.compactMap { item -> DiffableConversationViewItem? in
            guard !seen.contains(item.id) else {
                logger.error(message: "Found duplicated item in Conversation items", extra: ["id": item.id])
                return nil
            }
            seen.insert(item.id)
            return DiffableConversationViewItem(value: item)
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func reconfigure(item: DiffableConversationViewItem) {
        var snapshot = dataSource.snapshot()
        if #available(iOS 15.0, *) {
            snapshot.reconfigureItems([item])
        } else {
            snapshot.reloadItems([item])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func displayMediaSelectionSheet(sourceView: UIView) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if Bundle.main.nabla.hasCameraUsageDescription {
            let cameraAction = UIAlertAction(
                title: L10n.conversationAddMediaCamera,
                style: .default,
                handler: { [weak self] _ in
                    self?.presenter?.didTapCameraButton()
                }
            )
            cameraAction.isEnabled = !UIDevice.current.nabla.isSimulator
            alert.addAction(cameraAction)
        }
        alert.addAction(
            UIAlertAction(title: L10n.conversationAddMediaLibrary, style: .default, handler: { [weak self] _ in
                self?.presenter?.didTapPhotoLibraryButton()
            })
        )
        if Bundle.main.nabla.hasCameraUsageDescription {
            let scanDocumentAction = UIAlertAction(title: L10n.conversationAddMediaScanDocument, style: .default, handler: { [weak self] _ in
                self?.presenter?.didTapScanDocumentButton()
            })
            scanDocumentAction.isEnabled = !UIDevice.current.nabla.isSimulator
            alert.addAction(scanDocumentAction)
        }
        if #available(iOS 14, *) {
            alert.addAction(
                UIAlertAction(title: L10n.conversationAddMediaDocument, style: .default, handler: { [weak self] _ in
                    self?.presenter?.didTapDocumentLibraryButton()
                })
            )
        }
        alert.addAction(UIAlertAction(title: L10n.conversationAddMediaCancel, style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.frame
        alert.popoverPresentationController?.permittedArrowDirections = [.down]
        present(alert, animated: true, completion: nil)
    }

    private func updateComposerVisibility(showComposer: Bool) {
        loadedViewBottomConstraint?.isActive = false
        if showComposer {
            view.addSubview(composerView)
            composerView.nabla.pinToSuperView(edges: .nabla.horizontal)

            loadedView.bottomAnchor.constraint(equalTo: composerView.topAnchor).isActive = true
            loadedViewBottomConstraint = composerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
            loadedViewBottomConstraint?.isActive = true
        } else {
            composerView.removeFromSuperview()
            loadedViewBottomConstraint = loadedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            loadedViewBottomConstraint?.isActive = true
        }
    }
}

extension ConversationViewController: ConversationCellPresenterDelegate {
    // MARK: - ConversationCellPresenterDelegate
    
    func didUpdateState(forItemWithId id: UUID) {
        dataSource.snapshot()
            .itemIdentifiers
            .first { $0.value.id == id }
            .map(reconfigure)
    }
    
    func didDeleteItem(withId messageId: UUID) {
        presenter.didTapDeleteMessageButton(withId: messageId)
    }
    
    func didTap(document: DocumentFile) {
        presenter?.didTap(document: document)
    }

    func didTap(image: ImageFile) {
        presenter?.didTap(image: image)
    }

    func didTapTextItem(withId id: UUID) {
        presenter?.didTapTextItem(withId: id)
    }

    func didReplyToItem(withId id: UUID) {
        presenter?.didReplyToMessage(withId: id)
    }

    func didTapMessagePreview(withId id: UUID) {
        presenter?.didTapMessagePreview(withId: id)
    }
    
    func didTapJoinVideoCall(url: String, token: String) {
        presenter?.didTapJoinVideoCall(url: url, token: token)
    }
}

extension ConversationViewController: ComposerViewDelegate {
    // MARK: - ComposerViewDelegate
    
    func composerViewDidTapOnSend(_ composerView: ComposerView) {
        presenter.didTapOnSend(text: composerView.text, medias: composerView.medias, replyingToMessageUUID: composerView.replyToMessage?.id)
    }
    
    func composerViewDidUpdateTextDraft(_ composerView: ComposerView) {
        presenter.didUpdateDraftText(composerView.text)
    }
    
    func composerView(_: ComposerView, didTapOnAddMediaFrom sender: UIView) {
        displayMediaSelectionSheet(sourceView: sender)
    }

    func composerView(_: ComposerView, didFinishRecordingAudioFile file: AudioFile) {
        presenter.didFinishRecordingAudioFile(file, replyingToMessageUUID: composerView.replyToMessage?.id)
    }
}

extension ConversationViewController: ImagePickerDelegate {
    // MARK: - ImagePickerDelegate
    
    func imagePickerDidCancel(_ pickerViewController: UIViewController) {
        pickerViewController.dismiss(animated: true)
    }
    
    func imagePicker(_ pickerViewController: UIViewController, didSelect medias: [Media], errors _: [ImagePickerError]) {
        composerView.add(medias)
        pickerViewController.dismiss(animated: true)
    }
}

extension ConversationViewController: DocumentPickerDelegate {
    // MARK: - DocumentPickerDelegate
    
    func documentPickerDidCancel(_ pickerViewController: UIViewController) {
        pickerViewController.dismiss(animated: true)
    }
    
    func documentPicker(_ pickerViewController: UIViewController, didSelect media: Media) {
        composerView.add([media])
        pickerViewController.dismiss(animated: true)
    }
}

extension ConversationViewController: DocumentScannerDelegate {
    func documentScanner(_ scannerViewController: UIViewController, didScan pdfDocument: PDFDocument) {
        defer {
            scannerViewController.dismiss(animated: true)
        }
        guard let documentFile = ScannedPDFDocumentTransformer.transform(pdfDocument) else {
            logger.error(message: "Could not transform the scanned pdf document.")
            return
        }
        composerView.add([documentFile])
    }
}

struct DiffableConversationViewItem: Hashable {
    let value: ConversationViewItem
    
    func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
    
    static func == (lhs: DiffableConversationViewItem, rhs: DiffableConversationViewItem) -> Bool {
        lhs.value.hashValue == rhs.value.hashValue
    }
}

extension ConversationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndexPath = collectionView.lastIndexPath
        let isAlmostEndOfCollectionView = lastIndexPath.section == indexPath.section && lastIndexPath.item - indexPath.item < 5
        if isAlmostEndOfCollectionView {
            presenter.didReachEndOfConversation()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point _: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let conversationContextCell = collectionView.cellForItem(at: indexPath) as? ConversationContextCell,
              let menuConfiguration = conversationContextCell.makeContextMenuConfiguration(for: indexPath)
        else {
            return nil
        }
        
        return menuConfiguration.makeUIConfiguration()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.indexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? ConversationContextCell
        else {
            return nil
        }
        return cell.previewForHighlightingContextMenu()
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.indexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? ConversationContextCell
        else {
            return nil
        }
        return cell.previewForHighlightingContextMenu()
    }
}

private extension UICollectionView {
    var lastIndexPath: IndexPath {
        let section = numberOfSections - 1
        let item = numberOfItems(inSection: section) - 1
        return IndexPath(item: item, section: section)
    }
}

extension ConversationViewController: ErrorViewDelegate {
    func errorViewDidTapButton(_: ErrorView) {
        presenter.retry()
    }
}
