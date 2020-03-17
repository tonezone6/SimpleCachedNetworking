//

import Foundation
import SimpleNetworking

struct URLSessionMock: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    init(data: Data? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }
    
    func load<A: Codable>(_ type: A.Type, with request: URLRequest, completion: @escaping (Result<A, Error>) -> Void) {
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(A.self, from: data)
                completion(.success(value))
            } catch(let error) {
                completion(.failure(error))
            }
        }
        if let error = error {
            completion(.failure(error))
        }
    }
}
