import Foundation
import NablaMessagingCoreFork

struct DocumentDetailViewModelTransformer {
    // MARK: - Public
    
    func transform(document: DocumentFile) -> DocumentDetailViewModel {
        DocumentDetailViewModel(
            fileName: document.fileName,
            documentSource: document.content
        )
    }
}
