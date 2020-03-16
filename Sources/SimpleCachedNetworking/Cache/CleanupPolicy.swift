// SimpleCachedNetworking

import Foundation

public protocol CleanupPolicy {
    func itemsToRemove(from items: Set<CacheItem>) -> Set<CacheItem>
}

public struct CleanupPolicySize {
    public static let standard: Int64 = 50 * 1024 * 1024 // 50 MB
}

public struct MaxSizeCleanupPolicy: CleanupPolicy {
    let maxSize: Int64
    
    // 50MB
    public init(size: Int64 = CleanupPolicySize.standard) {
        maxSize = size
    }
    
    public func itemsToRemove(from items: Set<CacheItem>) -> Set<CacheItem> {
        var itemsToRemove = Set<CacheItem>()
        var cumulativeSize = 0
        let sorted = items.sorted(by: { $0.age < $1.age })
        for item in sorted {
            cumulativeSize += item.size
            if cumulativeSize > maxSize {
                itemsToRemove.insert(item)
            }
        }
        return itemsToRemove
    }
}
