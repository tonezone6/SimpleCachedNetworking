import XCTest
@testable import SimpleCachedNetworking

final class CacheItemTests: XCTestCase {
    
    func testCacheItemAge() {
        let date = Date().addingTimeInterval(-5)
        let item = CacheItem(id: "id", date: date, response: Data([0, 1]))
        XCTAssertEqual(item.age, 5, accuracy: 0.1)
    }
    
    func testCacheItemSize() {
        let item = CacheItem(id: "id", date: Date(), response: Data([0, 1]))
        XCTAssertEqual(item.size, 2)
    }
}

