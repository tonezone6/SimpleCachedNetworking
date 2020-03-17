import XCTest
@testable import SimpleCachedNetworking

final class CacheErrorTests: XCTestCase {
    
    func testCacheErrorInvalidKeyDescription() {
        let error = CacheError.invalidKey
        XCTAssertEqual(error.localizedDescription, "invalidKey")
    }
    
    func testCacheErrorInvalidMethodDescription() {
        let error = CacheError.invalidMethod
        XCTAssertEqual(error.localizedDescription, "invalidMethod")
    }
    
    func testCacheErrorDataUnavailableDescription() {
        let error = CacheError.dataUnavailable
        XCTAssertEqual(error.localizedDescription, "dataUnavailable")
    }
}

