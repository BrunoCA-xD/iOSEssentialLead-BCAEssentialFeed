import Foundation

public struct ImageCommentsViewModel: Equatable {
	public let comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Hashable {
	public let message: String
	public let createdAt: String
	public let author: String

	public init(message: String, createdAt: String, author: String) {
		self.message = message
		self.createdAt = createdAt
		self.author = author
	}
}
