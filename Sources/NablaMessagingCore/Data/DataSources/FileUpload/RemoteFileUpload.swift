import Foundation
import W_NablaCore

struct RemoteFileUpload {
    let fileName: String
    let content: MediaSource
    let mimeType: MimeType
    let purpose: Purpose
    
    enum Purpose: String {
        case message = "MESSAGE"
    }
}
