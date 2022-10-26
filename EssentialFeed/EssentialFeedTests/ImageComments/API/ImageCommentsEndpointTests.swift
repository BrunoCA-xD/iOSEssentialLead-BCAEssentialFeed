import XCTest
import EssentialFeed

final class ImageCommentsEndpointTests: XCTestCase {
	func test_imageComments_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!
		let imageID = UUID()

		let received = ImageCommentsEndpoint.get(imageID: imageID).url(baseURL: baseURL)
		let expected = URL(string: "http://base-url.com/v1/image/\(imageID.uuidString)/comments")!

		XCTAssertEqual(received, expected)
	}
}
