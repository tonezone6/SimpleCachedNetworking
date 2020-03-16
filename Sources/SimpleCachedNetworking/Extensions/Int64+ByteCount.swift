// SimpleCachedNetworking

import Foundation

extension Int64 {
    enum ByteCountUnit {
        case mb, kb
    }
    
    func description(using unit: ByteCountUnit) -> String {
        let formatter = ByteCountFormatter()
        switch unit {
        case .kb: formatter.allowedUnits = [.useKB]
        case .mb: formatter.allowedUnits = [.useMB]
        }
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: self)
    }
}
