// SimpleCachedNetworking

import Foundation

public struct CacheItem: Codable, Hashable {
    let id: String
    let date: Date
    let response: Data
    
    var age: TimeInterval {
        return Date().timeIntervalSince(date)
    }
    
    var size: Int {
        return response.count
    }
}

extension CacheItem {
    init(id: String, response: Data) {
        self.id = id
        self.date = Date()
        self.response = response
    }
}
