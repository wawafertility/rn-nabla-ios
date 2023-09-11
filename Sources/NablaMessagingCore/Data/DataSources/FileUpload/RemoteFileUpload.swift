import Foundation
import NablaCoreFork

struct RemoteFileUpload {
    let fileName: String
    let content: MediaSource
    let mimeType: MimeType
    let purpose: Purpose
    
    enum Purpose: String {
        case message = "MESSAGE"
    }
}
