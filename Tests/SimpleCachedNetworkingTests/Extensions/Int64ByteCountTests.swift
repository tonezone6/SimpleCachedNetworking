import XCTest
@testable import SimpleCachedNetworking

final class ByteCountDescriptionTests: XCTestCase {
   
    func testByteCountDescriptionUsingMegaBytes() {
        let size: Int64 = 50 * 1024 * 1024
        let description = size.description(using: .mb)
        XCTAssertEqual(description, "50 MB")
    }
    
    func testByteCountDescriptionUsingKiloBytes() {
        let size: Int64 = 50 * 1024 * 1024
        let description = size.description(using: .kb)
        XCTAssertEqual(description, "51,200 KB")
    }
}
