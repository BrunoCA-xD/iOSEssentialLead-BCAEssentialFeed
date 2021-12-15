import Foundation

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
            case .success(let resultTuple):
                if resultTuple.response.statusCode == 200,
                   let items = try? FeedItemsMapper.map(resultTuple.data, resultTuple.response) {
                    completion(.success(items))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
