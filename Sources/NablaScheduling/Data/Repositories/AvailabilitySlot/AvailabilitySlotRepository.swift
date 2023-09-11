import Combine
import Foundation
import NablaCoreFork

// sourcery: AutoMockable
// sourcery: typealias = "Category = NablaScheduling.Category"
protocol AvailabilitySlotRepository {
    func watchCategories() -> AnyPublisher<[Category], NablaError>
    func watchAvailabilitySlots(forCategoryWithId: UUID, location: LocationType) -> AnyPublisher<PaginatedList<AvailabilitySlot>, NablaError>
}
