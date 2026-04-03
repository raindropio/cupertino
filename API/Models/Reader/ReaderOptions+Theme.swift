import Foundation
import SwiftUI

extension ReaderOptions {
    public enum Theme: String, CaseIterable, Codable {
        case system = ""
        case day
        case night
        case sunset
        
        public var title: String {
            switch self {
            case .system: return String(localized: "System")
            case .day: return String(localized: "Day")
            case .night: return String(localized: "Night")
            case .sunset: return String(localized: "Sunset")
            }
        }
        
        public var systemImage: String {
            switch self {
            case .system: return "circle.lefthalf.filled"
            case .day: return "sun.min"
            case .night: return "moon"
            case .sunset: return "sun.and.horizon"
            }
        }
    }
}
