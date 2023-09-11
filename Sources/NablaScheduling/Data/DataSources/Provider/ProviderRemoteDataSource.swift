import Combine
import Foundation
import NablaCoreFork

protocol ProviderRemoteDataSource {
    func watchProvider(id: UUID) -> AnyPublisher<RemoteProvider, GQLError>
}
