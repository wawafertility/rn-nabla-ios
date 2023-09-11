import Foundation
import NablaCoreFork

extension ProviderNameComponents {
    init(_ provider: Provider) {
        self.init()
        prefix = provider.prefix
        firstName = provider.firstName
        lastName = provider.lastName
    }
}
