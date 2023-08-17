import Foundation
import W_NablaCore

protocol StartConversationInteractor {
    func execute(
        title: String?,
        providerIds: [UUID]?
    ) -> Conversation
}
