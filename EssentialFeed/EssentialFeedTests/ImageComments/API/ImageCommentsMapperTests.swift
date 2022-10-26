import XCTest
import EssentialFeed

final class ImageCommentsMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
		let json = makeItemsJSON([])
		let samples = [150, 199, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code)), "code is \(code)"
			)
		}
	}

	func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])
		let samples = [200, 230, 250, 280, 299]

		try samples.forEach { statusCode in
			let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: statusCode))

			XCTAssertEqual(result, [], "code is \(statusCode)")
		}
	}

	func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
		let invalidJSON = Data("invalid json".utf8)
		let samples = [200, 230, 250, 280, 299]

		try samples.forEach { statusCode in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: statusCode)), "code is \(statusCode)"
			)
		}
	}

	func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
		let item1 = makeItem(message: "message1", author: "author1")
		let item2 = makeItem()
		let json = makeItemsJSON([item1.json, item2.json])

		let samples = [200, 230, 250, 280, 299]

		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))

			XCTAssertEqual(result, [item1.model, item2.model], "code is \(code)")
		}
	}

	// MARK: - Helpers

	private func makeItem(id: UUID = UUID(), message: String = "any message", createdAt: Date = Date(timeIntervalSince1970: 1598627222), author: String = "any username") -> (model: ImageComment, json: [String: Any]) {
		let item = ImageComment(id: id, message: message, createdAt: createdAt, authorUsername: author)

		let json = [
			"id": id.uuidString,
			"message": message,
			"created_at": createdAt.ISO8601Format(),
			"author": [
				"username": author
			]
		].compactMapValues { $0 }

		return (item, json)
	}
}
