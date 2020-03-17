import XCTest
@testable import SimpleCachedNetworking

final class MaxSizeCleanupPolicyTests: XCTestCase {
    var cached: Set<CacheItem> {
        let cache1 = CacheItem(id: "1", date: Date().addingTimeInterval(-3), response: Data([0, 0, 1]))
        let cache2 = CacheItem(id: "2", date: Date().addingTimeInterval(-2), response: Data([0, 1, 1]))
        let cache3 = CacheItem(id: "3", date: Date().addingTimeInterval(-1), response: Data([1, 1, 1]))
        return [cache1, cache2, cache3]
    }
        
    func testPolicyItemsToRemoveCountIsOne() {
        let policy = MaxSizeCleanupPolicy(size: 7)
        let itemsToRemove = policy.itemsToRemove(from: cached)
        XCTAssertEqual(itemsToRemove.count, 1)
    }
    
    func testPolicyItemsToRemoveUnavailable() {
        let policy = MaxSizeCleanupPolicy(size: 10)
        let itemsToRemove = policy.itemsToRemove(from: cached)
        XCTAssertTrue(itemsToRemove.isEmpty)
    }
    
    func testPolicyItemsToRemoveOlderItems() {
        let policy = MaxSizeCleanupPolicy(size: 5)
        let itemsToRemove = policy.itemsToRemove(from: cached)
        let ids = Set(itemsToRemove.map { $0.id })
        XCTAssertEqual(ids, ["1", "2"])
    }
}
