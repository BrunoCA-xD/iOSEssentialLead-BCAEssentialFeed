import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            items.map { $0.feedItem }
        }
    }

    private struct Item: Equatable, Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let imageURL: URL
        
        var feedItem: FeedItem {
            return FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: imageURL
            )
        }
        
        private enum CodingKeys: String, CodingKey {
            case id
            case description
            case location
            case imageURL = "image"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
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
    
    private static var OK_200: Int { 200 }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else { return .failure(RemoteFeedLoader.Error.invalidData) }
        return .success(root.feed)
    }
}
