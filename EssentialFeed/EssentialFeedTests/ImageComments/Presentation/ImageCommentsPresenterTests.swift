import XCTest
import EssentialFeed

final class ImageCommentsPresenterTests: XCTestCase {
	func test_title_isLocalized() {
		XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
	}

	func test_map_createsViewModel() {
		let item1 = makeItem(createdAt: (Date().adding(days: -1), "1 day ago"))
		let item2 = makeItem(createdAt: (Date().adding(minutes: -30), "30 minutes ago"))
		let item3 = makeItem(createdAt: (Date().adding(days: -33), "1 month ago"))

		let viewModel = ImageCommentsPresenter.map([item1.data, item2.data, item3.data], locale: .init(identifier: "en_US"))

		XCTAssertEqual(viewModel.comments, [item1.viewModel, item2.viewModel, item3.viewModel])
	}

	// MARK: - Helpers
	private func makeItem(
		message: String = "any message",
		createdAt: (date: Date, formatted: String),
		authorUsername: String = "any username"
	) -> (data: ImageComment, viewModel: ImageCommentViewModel) {
		let data = ImageComment(id: UUID(), message: "any message", createdAt: createdAt.date, authorUsername: "any username")
		let model = ImageCommentViewModel(
			message: message,
			createdAt: createdAt.formatted,
			author: authorUsername
		)
		return (data, model)
	}

	private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
		let table = "ImageComments"
		let bundle = Bundle(for: ImageCommentsPresenter.self)
		let value = bundle.localizedString(forKey: key, value: nil, table: table)
		if value == key {
			XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
		}
		return value
	}
}
