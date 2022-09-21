import XCTest

final class FeedImagePresenter {
    init(view: Any) {
        
    }
}

final class FeedImagePresenterTests: XCTestCase {
    
   func test_init_doesNotSendMessagesToView() {
       let view = ViewSpy()
       
       _ = FeedImagePresenter(view: view)

       XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
   }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        var messages = [Any]()
    }
}
