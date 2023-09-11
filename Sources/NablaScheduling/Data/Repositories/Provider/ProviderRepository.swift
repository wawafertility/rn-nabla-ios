import Combine
import Foundation
import NablaCoreFork

// sourcery: AutoMockable
protocol ProviderRepository {
    func watchProvider(id: UUID) -> AnyPublisher<Provider, NablaError>
}
