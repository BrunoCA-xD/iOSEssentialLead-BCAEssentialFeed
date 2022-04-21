import Foundation

public protocol FeedStore {
    typealias InsertionCompletion = ((Error?) -> Void)
    typealias DeletionCompletion = ((Error?) -> Void)
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
}
