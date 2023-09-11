import NablaMessagingCoreFork

public extension NablaMessagingClient {
    var views: NablaMessagingViewFactory {
        NablaMessagingViewFactory(client: self)
    }
}
