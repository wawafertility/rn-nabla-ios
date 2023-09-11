import NablaCoreFork

public struct NablaMessagingModule: NablaCore.MessagingModule {
    public func makeClient(container: CoreContainer) -> MessagingClient {
        NablaMessagingClient(container: container)
    }
    
    public init() {}
}
