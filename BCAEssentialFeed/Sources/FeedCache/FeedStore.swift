import Foundation

public protocol FeedStore {
    typealias InsertionCompletion = ((Error?) -> Void)
    typealias DeletionCompletion = ((Error?) -> Void)
    typealias RetrievalCompletion = ((Error?) -> Void)
    
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
