import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(data: Data, response: HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
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
            case .success(let resultTuple):
                if resultTuple.response.statusCode == 200,
                    let root = try? JSONDecoder().decode(Root.self, from: resultTuple.data) {
                    let feedItems = root.items.map { $0.feedItem }
                    completion(.success(feedItems))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [Item]
}

private struct Item: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    var feedItem: FeedItem {
        return FeedItem(
            id: id,
            description: description,
            location: location,
            imageURL: imageURL
        )
    }
}

extension Item: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case imageURL = "image"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Self.CodingKeys)
        id = try container.decode(UUID.self, forKey: .id)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        let imageString = try container.decode(String.self, forKey: .imageURL)
        guard let url = URL(string: imageString) else {
            throw URLError(.badURL)
        }
        imageURL = url
    }
}
