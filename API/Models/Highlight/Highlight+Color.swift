import SwiftUI

extension Highlight {
    public enum Color: String, Codable {
        case blue, brown, cyan, gray, green, indigo, orange, pink, purple, red, teal, yellow
        
        public static let bestCases: [Self] = [.yellow, .blue, .green, .red]
        
        public var ui: SwiftUI.Color {
            switch self {
            case .blue: return .blue
            case .brown: return .brown
            case .cyan: return .cyan
            case .gray: return .gray
            case .green: return .green
            case .indigo: return .indigo
            case .orange: return .orange
            case .pink: return .pink
            case .purple: return .purple
            case .red: return .red
            case .teal: return .teal
            case .yellow: return .yellow
            }
        }
    }
}
