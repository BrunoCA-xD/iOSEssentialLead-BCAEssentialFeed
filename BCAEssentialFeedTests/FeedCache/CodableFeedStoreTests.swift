import XCTest
@testable import BCAEssentialFeed

class CodableFeedStore {
    
    func retrive(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
    
}

final class CodableFeedStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "wait for cache retrieval")
        
        sut.retrive { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("expected empty result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
