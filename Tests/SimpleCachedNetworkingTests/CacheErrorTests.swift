import XCTest
@testable import SimpleCachedNetworking

final class CacheErrorTests: XCTestCase {
    
    func testCacherErrorInvalidKeyDescription() {
        let error = CacheError.invalidKey
        XCTAssertEqual(error.localizedDescription, "invalidKey")
    }
    
    func testCacherErrorInvalidMethodDescription() {
        let error = CacheError.invalidMethod
        XCTAssertEqual(error.localizedDescription, "invalidMethod")
    }
}

