import NablaCoreFork

public extension NablaVideoCallClient {
    var views: NablaVideoCallViewFactory {
        NablaVideoCallViewFactoryImpl(client: self)
    }
    
    var crossModuleViews: VideoCallViewFactory {
        NablaVideoCallViewFactoryImpl(client: self)
    }
}
