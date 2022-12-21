import SwiftUI

enum PreferredTheme: String, CaseIterable {
    case automatic
    case light
    case dark
    
    static var `default`: Self {
        .automatic
    }
    
    var title: String {
        switch self {
        case .automatic: return "Automatic"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
