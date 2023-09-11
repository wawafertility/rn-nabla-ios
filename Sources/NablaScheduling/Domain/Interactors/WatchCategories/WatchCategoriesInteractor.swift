import Combine
import Foundation
import NablaCoreFork

protocol WatchCategoriesInteractor {
    func execute() -> AnyPublisher<[Category], NablaError>
}
