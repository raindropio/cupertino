import SwiftUI

public enum ItemStackStyle {
    case list
    case grid(CGFloat)
}

private struct ItemStackStyleKey: EnvironmentKey {
    static let defaultValue : ItemStackStyle = .list
}

public extension EnvironmentValues {
    var itemStackStyle: ItemStackStyle {
        get { self[ItemStackStyleKey.self] }
        set { self[ItemStackStyleKey.self] = newValue }
    }
}
