import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

public final class RemoteFeedLoader {
    public typealias Result = Swift.Result<[FeedItem], Error>
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(
        url: URL,
        client: HTTPClient
    ) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result  in
            switch result {
            case .success:
                completion(.failure(.invalidData))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
