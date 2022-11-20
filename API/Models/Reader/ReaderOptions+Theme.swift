import Foundation
import SwiftUI

extension ReaderOptions {
    public enum Theme: String, CaseIterable, Codable {
        case day
        case night
        case sunset
        
        public var colorScheme: ColorScheme {
            switch self {
            case .day, .sunset: return .light
            case .night: return .dark
            }
        }
    }
}
