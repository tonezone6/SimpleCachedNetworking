// SimpleCachedNetworking

import Foundation

public extension URLSession {
    static var cached: CachedSession {
        let storage = OnDiskStorage()
        let cache = Cache(storage: storage)
        return CachedSession(cache: cache)
    }
}
