import SwiftUI

public extension Color {
    #if canImport(UIKit)
    static var tertiaryLabel: Color { Color(UIColor.tertiaryLabel) }
    static var groupedBackground: Color { Color(UIColor.systemGroupedBackground) }
    static var secondaryGroupedBackground: Color { Color(UIColor.secondarySystemGroupedBackground) }
    #else
    static var tertiaryLabel: Color { Color(NSColor.tertiaryLabelColor) }
    static var groupedBackground: Color { Color(NSColor.controlBackgroundColor) }
    static var secondaryGroupedBackground: Color { Color(NSColor.windowBackgroundColor) }
    #endif
}
