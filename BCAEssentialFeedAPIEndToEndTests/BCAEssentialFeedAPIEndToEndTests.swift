import XCTest

@testable import BCAEssentialFeed

final class BCAEssentialFeedAPIEndToEndTests: XCTestCase {
    
    func test_endToEndServerGETFeedResult_matchesFixedTestAccountData() {
        switch getFeedResult() {
        case let .success(feed)?:
            XCTAssertEqual(feed.count, 8, "Expected 8 items in the test account feed")
            feed.enumerated().forEach { (index, item) in
                XCTAssertImagesEquals(item, expectedImage(at: index), comparedIndex: index)
            }
        case let .failure(error)?:
            XCTFail("Expected success, got \(error) instead")
        default:
            XCTFail("Expected success, got nil instead")
        }
    }
    
    // MARK: - Helper func
    
    private func getFeedResult(file: StaticString = #filePath, line: UInt = #line) -> RemoteFeedLoader.Result?{
        let testServerURL = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        let exp = expectation(description: "wait for load completion")
        
        var receivedResult: RemoteFeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 15)
        
        return receivedResult
    }
    
    private func XCTAssertImagesEquals(_ image1: FeedImage?, _ image2: FeedImage?, comparedIndex: Int, file: StaticString = #filePath, line: UInt = #line) {
        let failMessageSuffix = "does not match at index: \(comparedIndex)"
        
        if image1?.id != image2?.id {
            XCTFail("Items id \(failMessageSuffix)", file: file, line: line)
        } else if image1?.description != image2?.description {
            XCTFail("Items description \(failMessageSuffix)", file: file, line: line)
        } else if image1?.location != image2?.location {
            XCTFail("Items location \(failMessageSuffix)", file: file, line: line)
        } else if image1?.url != image2?.url {
            XCTFail("Items imageURL \(failMessageSuffix)", file: file, line: line)
        }
    }
    
    private func expectedImage(at index: Int) -> FeedImage? {
        FeedImage(
            id: id(at: index),
            description: description(at: index),
            location: location(at: index),
            url: url(at: index)
        )
    }
    
    private func id(at index: Int) -> UUID {
        return UUID(uuidString: [
            "73A7F70C-75DA-4C2E-B5A3-EED40DC53AA6",
            "BA298A85-6275-48D3-8315-9C8F7C1CD109",
            "5A0D45B3-8E26-4385-8C5D-213E160A5E3C",
            "FF0ECFE2-2879-403F-8DBE-A83B4010B340",
            "DC97EF5E-2CC9-4905-A8AD-3C351C311001",
            "557D87F1-25D3-4D77-82E9-364B2ED9CB30",
            "A83284EF-C2DF-415D-AB73-2A9B8B04950B",
            "F79BD7F8-063F-46E2-8147-A67635C3BB01"
        ][index])!
    }
    
    private func description(at index: Int) -> String? {
        return [
            "Description 1",
            nil,
            "Description 3",
            nil,
            "Description 5",
            "Description 6",
            "Description 7",
            "Description 8"
        ][index]
    }
    
    private func location(at index: Int) -> String? {
        return [
            "Location 1",
            "Location 2",
            nil,
            nil,
            "Location 5",
            "Location 6",
            "Location 7",
            "Location 8"
        ][index]
    }
    
    private func url(at index: Int) -> URL {
        return URL(string: [
            "https://url-1.com",
            "https://url-2.com",
            "https://url-3.com",
            "https://url-4.com",
            "https://url-5.com",
            "https://url-6.com",
            "https://url-7.com",
            "https://url-8.com"
        ][index])!
    }
}
