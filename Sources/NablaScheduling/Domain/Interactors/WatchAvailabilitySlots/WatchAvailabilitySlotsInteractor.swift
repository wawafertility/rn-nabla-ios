import Combine
import Foundation
import NablaCoreFork

protocol WatchAvailabilitySlotsInteractor {
    func execute(categoryId: UUID, location: LocationType) -> AnyPublisher<PaginatedList<AvailabilitySlot>, NablaError>
}
