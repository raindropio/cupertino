import SwiftUI

extension Admonition {
    public enum Role {
        case note
        case tip
        case info
        case caution
        case danger
        
        var tint: Color {
            switch self {
            case .note: return .secondary
            case .tip: return .green
            case .info: return .blue
            case .caution: return .yellow
            case .danger: return .red
            }
        }
        
        var systemImage: String {
            switch self {
            case .note: return "info.circle"
            case .tip: return "info.circle"
            case .info: return "info.circle"
            case .caution: return "exclamationmark.triangle"
            case .danger: return "exclamationmark.triangle"
            }
        }
    }
}
