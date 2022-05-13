import Foundation

public protocol FeedLoader {
    func load(completion: @escaping (Result<[FeedImage], Error>) -> Void)
}
