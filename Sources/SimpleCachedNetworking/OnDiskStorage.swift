// SimpleCachedNetworking

import Foundation

extension OnDiskStorage {
    private var documentsUrl: URL {
        guard let url = try? FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        else {
            fatalError("cannot get url for document directory")
        }
        return url
    }
    
    private var manager: FileManager { FileManager.default }
}

class OnDiskStorage: CacheProtocol {
    func save(_ data: Data?, for key: String) throws {
        let path = documentsUrl.appendingPathComponent(key)
        guard let value = data else {
            return try manager.removeItem(at: path) // clear old value if no data to save
        }
        try value.write(to: path)
    }
    
    func loadData(with key: String) throws -> Data {
        let path = documentsUrl.appendingPathComponent(key)
        return try Data(contentsOf: path)
    }
    
    func remove(_ key: String) throws {
        let path = documentsUrl.appendingPathComponent(key)
        try manager.removeItem(at: path)
    }
    
    func loadCurrentData() throws -> [Data] {
        let contents = try manager.contentsOfDirectory(
            at: documentsUrl, includingPropertiesForKeys: nil)
        return try contents.map { try Data(contentsOf: $0) }
    }
}
