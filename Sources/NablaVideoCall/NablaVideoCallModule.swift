import NablaCoreFork

public struct NablaVideoCallModule: NablaCoreFork.VideoCallModule {
    public func makeClient(container: CoreContainer) -> VideoCallClient {
        NablaVideoCallClient(container: container)
    }
    
    public init() {}
}
