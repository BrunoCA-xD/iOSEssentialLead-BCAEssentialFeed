import XCTest
import BCAEssentialFeed

struct FeedImageViewModel: Equatable {
    let description: String?
    let location: String?
    let image: Data?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    
    func display(_ model: FeedImageViewModel)
}

final class FeedImagePresenter {
    private let view: FeedImageView
    
    init(view: FeedImageView) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false)
        )
    }
}

final class FeedImagePresenterTests: XCTestCase {
    
   func test_init_doesNotSendMessagesToView() {
       let (_, view) = makeSUT()
       
       XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
   }
    
    func test_didStartLoadingImageData_shouldDisplaysLoadingStateAndShouldRetryState() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingImageData(for: uniqueImage())
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true),
            .display(shouldRetry: false)
        ])
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        
        return (sut, view)
    }
    
    private class ViewSpy: FeedImageView {
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(shouldRetry: Bool)
        }
        
        var messages = Set<Message>()
        
        func display(_ model: FeedImageViewModel) {
            messages.insert(.display(isLoading: model.isLoading))
            messages.insert(.display(shouldRetry: model.shouldRetry))
        }
    }
    
}
