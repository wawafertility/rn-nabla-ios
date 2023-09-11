import Combine
import Foundation
import NablaCoreFork

// sourcery: AutoMockable
protocol ConsentsRepository {
    func watchConsents(location: LocationType) -> AnyPublisher<Consents, NablaError>
}
