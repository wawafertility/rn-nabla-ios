import Foundation
import NablaCoreFork

enum FileUploadRemoteDataSourceError: Error {
    case cannotReadFileData
    case uploadError(UploadClientError)
    case unknownError(Error)
}

// sourcery: AutoMockable
protocol FileUploadRemoteDataSource {
    /// - Throws: ``FileUploadRemoteDataSourceError``
    func upload(file: RemoteFileUpload) async throws -> UUID
}
