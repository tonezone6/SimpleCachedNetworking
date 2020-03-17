// SimpleCachedNetworking

import Foundation

public protocol CacheProtocol {
    func save(_ data: Data?, for key: String) throws
    func loadData(with key: String) throws -> Data
    func loadCurrentData() throws -> [Data]
    func remove(_ key: String) throws
}

public enum CacheError: LocalizedError {
    case invalidKey
    case invalidMethod
    case dataUnavailable
    
    public var errorDescription: String? {
        return "\(self)"
    }
}

public struct Cache {
    private var storage: CacheProtocol
    
    init(storage: CacheProtocol) {
        self.storage = storage
    }
    
    func save<A: Encodable>(_ value: A, for request: URLRequest) throws {
        guard request.httpMethod == "GET" else {
            throw CacheError.invalidMethod
        }
        let encoder = JSONEncoder()
        
        let data = try encoder.encode(value)
        let key = try request.createCacheKey()
        let item = CacheItem(id: key, response: data)
       
        let cacheItemData = try encoder.encode(item)
        try storage.save(cacheItemData, for: key)
    }
    
    func load<B: Decodable>(_ type: B.Type, for request: URLRequest) throws -> B {
        let decoder = JSONDecoder()
        
        let key = try request.createCacheKey()
        let cacheData = try storage.loadData(with: key)
        let item = try decoder.decode(CacheItem.self, from: cacheData)
        let resource = try decoder.decode(B.self, from: item.response)
        return resource
    }
    
    func cleanup() throws {
        let cached = try loadCached()
        let cacheKeys = cached.map({ $0.id })
        for key in cacheKeys {
            try storage.remove(key)
        }
    }
    
    func cleanup(policy: CleanupPolicy) throws {
        let cached = try loadCached()
        let items = policy.itemsToRemove(from: Set(cached))
        let cacheKeys = items.map({ $0.id })
        for key in cacheKeys {
            try storage.remove(key)
        }
    }
    
    private func loadCached() throws -> [CacheItem] {
        let stored = try storage.loadCurrentData()
        let cached: [CacheItem] = try stored.compactMap {
            try JSONDecoder().decode(CacheItem.self, from: $0)
        }
        return cached
    }
}

//extension Cache {
//    func logReport() throws {
//        let stored = try storage.loadCurrentData()
//
//        let cached: [CacheItem] = try stored.compactMap {
//            try JSONDecoder().decode(CacheItem.self, from: $0)
//        }
//
//        print("\ncached items:")
//        for item in cached {
//            print("id: \(item.id), age: \(item.age), size: \(item.size)")
//        }
//
//        print("\ncache report:")
//        let total = cached.reduce(0) { $0 + $1.size }
//        print("total size:", Int64(total).description(using: .kb))
//    }
//}
