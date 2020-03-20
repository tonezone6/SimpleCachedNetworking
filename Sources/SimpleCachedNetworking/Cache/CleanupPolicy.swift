// SimpleCachedNetworking

import Foundation

public protocol CleanupPolicy {
    func itemsToRemove(from items: Set<CacheItem>) -> Set<CacheItem>
}

public struct CleanupPolicySize {
    public static let standard: Int64 = 50 * 1024 * 1024 // 50 MB
}

public struct MaxSizeCleanupPolicy: CleanupPolicy {
    let size: Int64
    
    public init(size: Int64) {
        self.size = size
    }
    
    public func itemsToRemove(from items: Set<CacheItem>) -> Set<CacheItem> {
        var itemsToRemove = Set<CacheItem>()
        var cumulativeSize = 0
        let sorted = items.sorted(by: { $0.age < $1.age })
        for item in sorted {
            cumulativeSize += item.size
            if cumulativeSize > size {
                itemsToRemove.insert(item)
            }
        }
        print("MaxSizeCleanupPolicy items to remove", itemsToRemove.count)
        return itemsToRemove
    }
}
