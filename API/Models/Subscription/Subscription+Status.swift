import SwiftUI

extension Subscription {
    public enum Status: String, Codable {
        case active
        case payment_failed
        case canceled
        case deactivated
        case unknown
        
        public var title: String {
            switch self {
            case .active: return "Active"
            case .payment_failed: return "Payment failed"
            case .canceled: return "Canceled"
            case .deactivated: return "Deactivated"
            case .unknown: return "Unknown"
            }
        }
        
        public var systemImage: String {
            switch self {
            case .active: return "checkmark"
            case .payment_failed: return "exclamationmark.triangle"
            case .canceled: return "stop"
            case .deactivated: return "xmark"
            case .unknown: return "exclamationmark"
            }
        }
        
        public var color: Color {
            switch self {
            case .active: return .green
            case .payment_failed: return .red
            case .canceled: return .yellow
            case .deactivated: return .red
            case .unknown: return .gray
            }
        }
    }
}
