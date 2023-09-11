import Foundation
import NablaCoreFork
import NablaMessagingCoreFork

public extension PatientNameComponents {
    init(_ patient: Patient) {
        self.init(displayName: patient.displayName)
    }
}
