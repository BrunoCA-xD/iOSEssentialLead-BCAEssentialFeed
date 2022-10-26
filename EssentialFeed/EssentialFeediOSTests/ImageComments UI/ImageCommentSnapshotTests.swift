import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class ImageCommentSnapshotTests: XCTestCase {
	func test_loadedImageComments() {
		let sut = makeSUT()

		sut.display(makeComments())

		assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LOADED_IMAGE_COMMENTS_dark")
		assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LOADED_IMAGE_COMMENTS_light")
		assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "LOADED_IMAGE_COMMENTS_light_extraExtraExtraLarge")
	}

	// MARK: - Helpers

	private func makeSUT() -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let controller = storyboard.instantiateInitialViewController() as! ListViewController
		controller.loadViewIfNeeded()
		controller.tableView.showsVerticalScrollIndicator = false
		controller.tableView.showsHorizontalScrollIndicator = false
		return controller
	}

	private func makeComments() -> [CellController] {
		[
			ImageCommentViewModel(
				message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the ",
				createdAt: "1 year ago",
				author: "a username"
			),
			ImageCommentViewModel(
				message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
				createdAt: "3 months ago",
				author: "a long long long long long long long username"
			),
			ImageCommentViewModel(
				message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
				createdAt: "3 months ago",
				author: "a."
			)
		].map { CellController(id: $0, ImageCommentCellController(viewModel: $0)) }
	}
}
