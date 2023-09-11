import Combine
import Foundation
import NablaCoreFork

protocol WatchAppointmentInteractor {
    func execute(id: UUID) -> AnyPublisher<Appointment, NablaError>
}
