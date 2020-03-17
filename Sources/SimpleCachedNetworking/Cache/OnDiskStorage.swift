// SimpleCachedNetworking

import Foundation

class OnDiskStorage {
    private let manager = FileManager.default
    
    private func getDocumentsUrl() throws -> URL {
        try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

extension OnDiskStorage: CacheProtocol {
    func save(_ data: Data?, for key: String) throws {
        let path = try getDocumentsUrl().appendingPathComponent(key)
        guard let value = data else {
            return try manager.removeItem(at: path) // clear old value if no data to save
        }
        try value.write(to: path)
    }
    
    func loadData(with key: String) throws -> Data {
        let path = try getDocumentsUrl().appendingPathComponent(key)
        return try Data(contentsOf: path)
    }
    
    func remove(_ key: String) throws {
        let path = try getDocumentsUrl().appendingPathComponent(key)
        try manager.removeItem(at: path)
    }
    
    func loadCurrentData() throws -> [Data] {
        let path = try getDocumentsUrl()
        let contents = try manager.contentsOfDirectory(
            at: path, includingPropertiesForKeys: nil)
        
        return try contents.map { try Data(contentsOf: $0) }
    }
}
