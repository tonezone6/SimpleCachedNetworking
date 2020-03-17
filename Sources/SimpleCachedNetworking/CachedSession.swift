// SimpleCachedNetworking

import Foundation
import SimpleNetworking

public struct CachedSession {
    private var cache: Cache
    private var session: URLSessionProtocol
    
    public init(cache: Cache, session: URLSessionProtocol = URLSession.shared) {
        self.cache = cache
        self.session = session
    }
    
    public func load<T: Codable>(_ type: T.Type,
                          fromCache: Bool = true,
                          with request: URLRequest,
                          completion: @escaping (Result<T, Error>) -> Void) {
        
        if let cached = try? cache.load(T.self, for: request), fromCache == true {
            return completion(.success(cached))
        }
        
        session.load(T.self, with: request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let value):
                try? self.cache.save(value, for: request)
                completion(.success(value))
            }
        }
    }
    
    public func cleanup() throws {
        try cache.cleanup()
    }

    public func cleanup(using policy: CleanupPolicy) throws {
        try cache.cleanup(policy: policy)
    }
}
