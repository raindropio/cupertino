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
            case .system: return "System"
            case .day: return "Day"
            case .night: return "Night"
            case .sunset: return "Sunset"
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
