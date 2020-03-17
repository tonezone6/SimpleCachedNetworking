import XCTest
@testable import SimpleCachedNetworking

final class RequestCacheKeyTests: XCTestCase {
   
    func testRequestCacheKeyValid() throws {
        // given
        let url = URL(fileURLWithPath: "/path")
        
        // when
        let request = URLRequest(url: url)
        
        // then
        let prefix = "simpleCache" + "_"
        let digest = "73e69922b0bfea103781b52d1b6a2e3b09cd9f8f"
        XCTAssertEqual(try request.createCacheKey(), prefix + digest)
    }
    
    func testRequestCacheKeyInvalid() throws {
        let url = URL(fileURLWithPath: "/path")
        let request = URLRequest(url: url)
        XCTAssertNotEqual(try request.createCacheKey(), "some_prefixed_digest")
    }
    
    func testRequestCacheKeyThrowsInvalidKeyError() throws {
        // given
        let url = URL(fileURLWithPath: "")
        var request = URLRequest(url: url)
        
        // when
        request.url = nil

        // then
        XCTAssertThrowsError(try request.createCacheKey()) { error in
            XCTAssertEqual(error as? CacheError, .invalidKey)
        }
    }
}
