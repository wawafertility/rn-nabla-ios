import Combine
import Foundation
import NablaCoreFork

protocol AppointmentRemoteDataSource {
    func watchAppointments(state: AppointmentStateFilter) -> AnyPublisher<AnyResponse<PaginatedList<RemoteAppointment>, GQLError>, GQLError>
    func watchAppointment(withId id: UUID) -> AnyPublisher<RemoteAppointment, GQLError>
    func subscribeToAppointmentsEvents() -> AnyPublisher<RemoteAppointmentsEvent, Never>
    /// - Throws: ``GQLError``
    func createPendingAppointment(
        isPhysical: Bool,
        categoryId: UUID,
        providerId: UUID,
        date: Date
    ) async throws -> RemoteAppointment
    /// - Throws: ``GQLError``
    func schedulePendingAppointment(withId: UUID) async throws -> RemoteAppointment
    /// - Throws: ``GQLError``
    func cancelAppointment(withId: UUID) async throws
    /// - Throws: ``GQLError``
    func getAvailableLocations() async throws -> RemoteAvailableLocations
}
