import NablaCoreFork

public struct NablaMessagingModule: NablaCoreFork.MessagingModule {
    public func makeClient(container: CoreContainer) -> MessagingClient {
        NablaMessagingClient(container: container)
    }
    
    public init() {}
}
