import NablaCoreFork

public struct NablaSchedulingModule: NablaCoreFork.SchedulingModule {
    public func makeClient(container: CoreContainer) -> SchedulingClient {
        NablaSchedulingClient(container: container)
    }
    
    public init() {}
}
