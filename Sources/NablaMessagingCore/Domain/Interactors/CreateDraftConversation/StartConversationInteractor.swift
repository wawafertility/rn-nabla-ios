import Foundation
import NablaCoreFork

protocol StartConversationInteractor {
    func execute(
        title: String?,
        providerIds: [UUID]?
    ) -> Conversation
}
