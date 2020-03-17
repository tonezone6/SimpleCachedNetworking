//
import Foundation

extension URLRequest {
    static var mockGET: URLRequest {
        let url = URL(fileURLWithPath: "")
        return URLRequest(url: url)
    }
    
    static var mockPOST: URLRequest {
        let url = URL(fileURLWithPath: "")
        let body = ResourceMock(foo: "foo", bar: "bar")
        return URLRequest(url: url, body: body)
    }
}

