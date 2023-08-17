import Combine
import Foundation

final class InitializeInteractorImpl: InitializeInteractor {
    // MARK: - Internal
    
    func execute(apiKey: String) {
        extraHeaders.set(environment.platform, for: HTTPHeaders.Platform)
        extraHeaders.set(environment.version, for: HTTPHeaders.Version)
        extraHeaders.set(formatApiKey(apiKey), for: HTTPHeaders.NablaApiKey)
        
        currentUserObserver = userRepository
            .watchCurrentUser()
            .compactMap { $0 }
            .sink(receiveValue: { [deviceRepository, modules, logger] user in
                Task {
                    do {
                        try await deviceRepository.updateOrRegisterDevice(userId: user.id, withModules: modules)
                    } catch {
                        logger.warning(message: "Failed to register device", error: error, extra: ["user": user.id])
                    }
                }
            })
    }
    
    init(
        deviceRepository: DeviceRepository,
        userRepository: UserRepository,
        errorReporter: ErrorReporter,
        environment: Environment,
        extraHeaders: ExtraHeaders,
        logger: Logger,
        modules: [Module]
    ) {
        self.deviceRepository = deviceRepository
        self.userRepository = userRepository
        self.errorReporter = errorReporter
        self.environment = environment
        self.extraHeaders = extraHeaders
        self.logger = logger
        self.modules = modules
    }
    
    // MARK: - Private
    
    private let deviceRepository: DeviceRepository
    private let userRepository: UserRepository
    private let errorReporter: ErrorReporter
    private let environment: Environment
    private let extraHeaders: ExtraHeaders
    private let logger: Logger
    private let modules: [Module]
    
    private var currentUserObserver: Cancellable?
    
    private func formatApiKey(_ apiKey: String) -> String {
        apiKey.replacingOccurrences(of: "Authorization: Bearer ", with: "")
    }
}
