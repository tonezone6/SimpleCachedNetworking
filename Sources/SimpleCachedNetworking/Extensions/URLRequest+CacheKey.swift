//

import Foundation

extension URLRequest {
    func createCacheKey() throws -> String {
        guard let data = url?.absoluteString.data(using: .utf8) else {
            throw CacheError.invalidKey
        }
        return "simpleCache" + "_" + data.sha1
    }
}

