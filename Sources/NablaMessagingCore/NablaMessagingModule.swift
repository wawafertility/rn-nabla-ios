import W_NablaCore

public struct NablaMessagingModule: W_NablaCore.MessagingModule {
    public func makeClient(container: CoreContainer) -> MessagingClient {
        NablaMessagingClient(container: container)
    }
    
    public init() {}
}
