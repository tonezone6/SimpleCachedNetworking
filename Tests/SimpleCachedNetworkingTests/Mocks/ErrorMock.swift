import Foundation

enum ErrorMock: LocalizedError {
    case test
    
    var errorDescription: String? {
        return "\(self)"
    }
}
