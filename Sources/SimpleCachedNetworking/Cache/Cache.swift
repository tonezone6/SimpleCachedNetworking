// SimpleCachedNetworking

import Foundation

protocol CacheProtocol {
    func save(_ data: Data?, for key: String) throws
    func loadData(with key: String) throws -> Data
    func loadCurrentData() throws -> [Data]
    func remove(_ key: String) throws
}

extension URLRequest {
    var cacheKey: String? {
        guard let data = url?.absoluteString.data(using: .utf8) else { return nil }
        return "simpleCache" + "_" + data.sha1
    }
}

enum CacheError: Error {
    case cannotFindKey
}

public struct Cache {
    private var storage: CacheProtocol
    
    init(storage: CacheProtocol) {
        self.storage = storage
    }
    
    func save<A: Encodable>(_ value: A, for request: URLRequest) throws {
        guard request.httpMethod == "GET", let key = request.cacheKey else {
            return
        }
        let encoder = JSONEncoder()
        let responseData = try encoder.encode(value)
        let cacheItem = CacheItem(id: key, response: responseData)
        let data = try encoder.encode(cacheItem)
        try storage.save(data, for: key)
    }
    
    func load<B: Decodable>(_ type: B.Type, for request: URLRequest) throws -> B {
        guard let key = request.cacheKey else {
            throw CacheError.cannotFindKey
        }
        let decoder = JSONDecoder()
        let cacheData = try storage.loadData(with: key)
        let cacheItem = try decoder.decode(CacheItem.self, from: cacheData)
        return try decoder.decode(B.self, from: cacheItem.response)
    }
    
    func cleanup(policy: CleanupPolicy) throws {
        let stored = try storage.loadCurrentData()
        
        let cached: [CacheItem] = try stored.compactMap {
            try JSONDecoder().decode(CacheItem.self, from: $0)
        }

        let items = policy.itemsToRemove(from: Set(cached))
        for key in items.map({ $0.id }) {
            try storage.remove(key)
        }
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
