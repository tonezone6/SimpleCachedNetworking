//
import Foundation
import SimpleCachedNetworking

class StorageMock: CacheProtocol {
    var dataDictionary: [String : Data] = [:]
    
    func save(_ data: Data?, for key: String) throws {
        dataDictionary.updateValue(data ?? Data(), forKey: key)
    }
    
    func loadData(with key: String) throws -> Data {
        guard let data = dataDictionary[key] else {
            throw CacheError.dataUnavailable
        }
        return data
    }
    
    func loadCurrentData() throws -> [Data] {
        var array: [Data] = []
        for key in dataDictionary.keys {
            array.append(try loadData(with: key))
        }
        return array
    }
    
    func remove(_ key: String) throws {
        dataDictionary.removeValue(forKey: key)
    }
}
