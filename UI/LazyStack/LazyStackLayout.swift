import SwiftUI

public enum LazyStackLayout: Hashable {
    case list
    case grid(CGFloat, Bool)
        
    static func gap(_ layout: Self) -> CGFloat {
        20
    }
}

private struct LazyStackLayoutKey: EnvironmentKey {
    static let defaultValue: LazyStackLayout? = nil
}

extension EnvironmentValues {
    var lazyStackLayout: LazyStackLayout? {
        get { self[LazyStackLayoutKey.self] }
        set { self[LazyStackLayoutKey.self] = newValue }
    }
}
