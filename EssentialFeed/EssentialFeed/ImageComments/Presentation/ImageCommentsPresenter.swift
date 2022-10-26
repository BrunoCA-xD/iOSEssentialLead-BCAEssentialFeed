import Foundation

public final class ImageCommentsPresenter {
	private init() {}

	public static var title: String {
		NSLocalizedString(
			"IMAGE_COMMENTS_VIEW_TITLE",
			tableName: "ImageComments",
			bundle: Bundle(for: ImageCommentsPresenter.self),
			comment: "Title for the image comments view")
	}

	public static func map(
		_ imageComments: [ImageComment],
		calendar: Calendar = .current,
		locale: Locale = .current,
		now: Date = Date()
	) -> ImageCommentsViewModel {
		let relativeFormatter = RelativeDateTimeFormatter()
		relativeFormatter.calendar = calendar
		relativeFormatter.locale = locale

		return ImageCommentsViewModel(comments: imageComments.map {
			ImageCommentViewModel(
				message: $0.message,
				createdAt: relativeFormatter.localizedString(for: $0.createdAt, relativeTo: now),
				author: $0.authorUsername
			)
		})
	}
}
