import Foundation

/// A ``Cancellable`` task that handles pagination.
/// Used to fetch list of items, you must call loadMore when reaching end of list.
/// The items are received via the associated list watcher callback.
public protocol PaginatedWatcher: Cancellable {
    /// Load more items.
    /// The number of items returned is computed by the backed.
    /// - Parameters:
    ///   - callback: The completion to handle whether or not the task failed. The results are received via the associated list watcher callback.
    /// - Returns: The ``Cancellable`` of the task.
    func loadMore(completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable
    /// Load more items.
    /// - Parameters:
    ///   - numberOfItems: The number of items to load.
    ///   - callback: The completion to handle whether or not the task failed. The results are received via the associated list watcher callback.
    /// - Returns: The ``Cancellable`` of the task.
    func loadMore(numberOfItems: Int, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable
}

final class FailurePaginatedWatcher: PaginatedWatcher {
    func loadMore(completion _: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
        Failure()
    }

    func loadMore(numberOfItems _: Int, completion _: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
        Failure()
    }

    func cancel() {}
}
