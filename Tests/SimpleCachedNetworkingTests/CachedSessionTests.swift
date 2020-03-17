import XCTest
@testable import SimpleCachedNetworking

final class CachedSessionTests: XCTestCase {
    var storage: StorageMock!
    var cache: Cache!
    var session: URLSessionMock!
    var cachedSession: CachedSession!
    
    let request = URLRequest.mockGET
    var testData: Data? {
        return """
        {
            "foo" : "foo",
            "bar" : "bar"
        }
        """.data(using: .utf8)
    }
    
    override func setUp() {
        storage = StorageMock()
        cache = Cache(storage: storage)
    }
    
    override func tearDown() {
        storage = nil
        cache = nil
        session = nil
        cachedSession = nil
    }
    
    func testCachedSessionDidReceiveError() {
        // given
        session = URLSessionMock(error: ErrorMock.test)
        cachedSession = CachedSession(cache: cache, session: session)
    
        // when
        var result: Result<ResourceMock, Error>?
        cachedSession.load(ResourceMock.self, fromCache: false, with: request) { result = $0 }
    
        // then
        if case .failure(let error) = result {
            XCTAssertEqual(error.localizedDescription, "test")
        }
    }
    
    func testSessionDidCacheResource() throws {
        // given
        session = URLSessionMock(data: testData)
        cachedSession = CachedSession(cache: cache, session: session)
    
        // when
        cachedSession.load(ResourceMock.self, fromCache: false, with: request) { _ in }
    
        // then
        XCTAssertEqual(storage.dataDictionary.keys.count, 1)
    }
    
    func testSessionDidLoadResourceFromCache() throws {
        // given
        session = URLSessionMock(data: testData)
        cachedSession = CachedSession(cache: cache, session: session)
        cachedSession.load(ResourceMock.self, fromCache: false, with: request) { _ in }
    
        // when
        var result: Result<ResourceMock, Error>?
        cachedSession.load(ResourceMock.self, fromCache: true, with: request) { result = $0 }
        
        // then
        let decoded = try result?.get()
        XCTAssertEqual(decoded?.foo, "foo")
        XCTAssertEqual(decoded?.bar, "bar")
    }
    
    func testSessionCleanup() throws {
        // given
        session = URLSessionMock(data: testData)
        cachedSession = CachedSession(cache: cache, session: session)
        cachedSession.load(ResourceMock.self, fromCache: false, with: request) { _ in }
        
        // when
        try cachedSession.cleanup()

        // then
        XCTAssertTrue(storage.dataDictionary.keys.isEmpty)
    }
    
    func testSessionCleanupUsingPolicy() throws {
        // given
        session = URLSessionMock(data: testData)
        cachedSession = CachedSession(cache: cache, session: session)
        cachedSession.load(ResourceMock.self, fromCache: false, with: request) { _ in }
        
        // when
        // resource mock data: 25 KB
        let policy = MaxSizeCleanupPolicy(size: 20)
        try cachedSession.cleanup(using: policy)

        // then
        XCTAssertTrue(storage.dataDictionary.keys.isEmpty)
    }
    
    func testSessionCleanupUsingPolicyNoItemsToRemove() throws {
        // given
        session = URLSessionMock(data: testData)
        cachedSession = CachedSession(cache: cache, session: session)
        cachedSession.load(ResourceMock.self, fromCache: false, with: request) { _ in }
        
        // when
        // resource mock data: 25 KB
        let policy = MaxSizeCleanupPolicy(size: 30)
        try cachedSession.cleanup(using: policy)

        // then
        XCTAssertFalse(storage.dataDictionary.keys.isEmpty, "Cleanup policy max size greater than resource size")
    }
}
