import Combine
import Foundation
import NablaCoreFork

protocol WatchConsentsInteractor {
    func execute(location: LocationType) -> AnyPublisher<Consents, NablaError>
}
