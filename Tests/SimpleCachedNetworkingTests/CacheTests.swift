import XCTest
@testable import SimpleCachedNetworking

final class CacheTests: XCTestCase {
    var storage: StorageMock!
    var cache: Cache!
    let resource = ResourceMock.instance

    override func setUp() {
        storage = StorageMock()
        cache = Cache(storage: storage)
    }
    
    override func tearDown() {
        storage = nil
        cache = nil
    }
    
    func testCacheSave() throws {
        let request = URLRequest.mockGET
        let key = try request.createCacheKey()
       
        try cache.save(resource, for: request)
        
        XCTAssertNotNil(storage.dataDictionary[key])
    }
    
    func testCacheSavePostRequestThrowsError() throws {
        let request = URLRequest.mockPOST
        
        XCTAssertThrowsError(try cache.save(resource, for: request)) { error in
            XCTAssertEqual(error as? CacheError, .invalidMethod)
        }
    }
    
    func testCacheLoadResource() throws {
        let request = URLRequest.mockGET
        try cache.save(resource, for: request)
      
        let resource = try cache.load(ResourceMock.self, for: request)
       
        XCTAssertEqual(resource.foo, "foo")
        XCTAssertEqual(resource.bar, "bar")
    }
    
    func testCacheCleanup() throws {
        try cache.save(resource, for: URLRequest.mockGET)
        
        try cache.cleanup()
        
        XCTAssertEqual(storage.dataDictionary.keys.count, 0)
    }
    
    func testCacheCleanupWithPolicy() throws {
        let request = URLRequest.mockGET
        try cache.save(resource, for: request)
        
        // resource mock data: 25 KB
        let policy = MaxSizeCleanupPolicy(size: 24)
        try cache.cleanup(policy: policy)
        
        XCTAssertEqual(storage.dataDictionary.keys.count, 0)
    }
    
    func testCacheCleanupWithPolicyNoItemsToRemove() throws {
        let request = URLRequest.mockGET
        try cache.save(resource, for: request)
        
        // resource mock data: 25 KB
        let policy = MaxSizeCleanupPolicy(size: 26)
        try cache.cleanup(policy: policy)
        
        XCTAssertEqual(storage.dataDictionary.keys.count, 1)
    }
}
