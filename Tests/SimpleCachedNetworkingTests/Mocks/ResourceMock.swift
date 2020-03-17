import Foundation

struct ResourceMock: Codable {
    let foo: String
    let bar: String
}

extension ResourceMock {
    static let instance = ResourceMock(foo: "foo", bar: "bar")
}
