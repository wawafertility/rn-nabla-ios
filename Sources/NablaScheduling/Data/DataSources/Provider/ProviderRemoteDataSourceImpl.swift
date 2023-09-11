import Combine
import Foundation
import NablaCoreFork

final class ProviderRemoteDataSourceImpl: ProviderRemoteDataSource {
    // MARK: - Internal

    func watchProvider(id: UUID) -> AnyPublisher<RemoteProvider, GQLError> {
        gqlClient.watch(
            query: GQL.GetProviderQuery(providerId: id),
            policy: .returnCacheDataAndFetch
        )
        .compactMap { response -> RemoteProvider? in
            response.provider.provider.fragments.providerFragment
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: Init
    
    init(
        gqlClient: GQLClient
        
    ) {
        self.gqlClient = gqlClient
    }
    
    // MARK: - Private
    
    private let gqlClient: GQLClient
}
