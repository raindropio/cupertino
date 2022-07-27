import Foundation

class ItemStackConstants {
    #if os(macOS)
    static let padding: CGFloat = 14
    static let gap: CGFloat = 12
    #else
    static let padding: CGFloat = 16
    static let gap: CGFloat = 8
    #endif
}
