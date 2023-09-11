import Combine
import Foundation
import NablaCoreFork

protocol WatchProviderInteractor {
    func execute(providerId: UUID) -> AnyPublisher<Provider, NablaError>
}
