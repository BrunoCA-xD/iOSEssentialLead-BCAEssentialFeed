import Foundation

public enum ImageCommentsEndpoint {
	case get(imageID: UUID)

	public func url(baseURL: URL) -> URL {
		switch self {
		case let .get(imageID):
			return baseURL
				.appendingPathComponent("/v1/image/\(imageID.uuidString)/comments")
		}
	}
}
