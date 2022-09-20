import Foundation

public struct FeedErrorViewModel {
    public let errorMessage: String?
    
    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(errorMessage: nil)
    }
    
    static func error(errorMessage: String) -> FeedErrorViewModel {
        FeedErrorViewModel(errorMessage: errorMessage)
    }
}
