import XCTest
import BCAEssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
   
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        let exp = expectation(description: "wait for load completion")
        
        var receivedError: NSError?
        sut.load { result in
            switch result {
            case .failure(let error):
                receivedError = error as NSError?
            default:
                XCTFail("expect failure, but got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError?.code, retrievalError.code)
        XCTAssertEqual(receivedError?.domain, retrievalError.domain)
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "wait for load completion")

        var receivedImages: [FeedImage]?
        sut.load { result in
            switch result {
            case .success(let feedImages):
                receivedImages = feedImages
            default:
                XCTFail("expect success, but got \(result) instead")
            }
            exp.fulfill()
        }

        store.completeRetrievalWithEmptyCache()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedImages?.count, 0)
    }
    
    // MARK: helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString =  #filePath, line: UInt = #line) -> (LocalFeedLoader, FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
