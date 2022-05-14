import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found([LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias InsertionCompletion = ((Error?) -> Void)
    typealias DeletionCompletion = ((Error?) -> Void)
    typealias RetrievalCompletion = ((RetrieveCachedFeedResult) -> Void)
    
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
