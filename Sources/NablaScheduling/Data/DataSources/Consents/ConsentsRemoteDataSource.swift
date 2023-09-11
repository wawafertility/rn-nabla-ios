import Combine
import Foundation
import NablaCoreFork

// sourcery: AutoMockable
protocol ConsentsRemoteDataSource {
    func watchConsents() -> AnyPublisher<RemoteConsents, GQLError>
}
