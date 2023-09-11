import Foundation
import NablaMessagingCoreFork

class DocumentDetailPresenterImpl: DocumentDetailPresenter {
    // MARK: - Initializer
    
    init(viewContract: DocumentDetailViewContract, document: DocumentFile) {
        self.viewContract = viewContract
        self.document = document
    }
    
    // MARK: - Presenter
    
    func start() {
        let transformer = DocumentDetailViewModelTransformer()
        let viewModel = transformer.transform(document: document)
        viewContract?.configure(with: viewModel)
    }
    
    // MARK: - DocumentDetailPresenter
    
    // MARK: - Private
    
    private weak var viewContract: DocumentDetailViewContract?
    private let document: DocumentFile
}
