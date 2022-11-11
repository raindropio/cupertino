import SwiftUI

public enum LazyStackLayout: Hashable, Equatable {
    case list
    case grid(Double, Bool)
        
    static func gap(_ layout: Self) -> Double {
        20
    }
}

private struct LazyStackLayoutKey: EnvironmentKey {
    static let defaultValue: LazyStackLayout? = nil
}

extension EnvironmentValues {
    var lazyStackLayout: LazyStackLayout? {
        get {
            self[LazyStackLayoutKey.self]
        }
        set {
            if self[LazyStackLayoutKey.self] != newValue {
                self[LazyStackLayoutKey.self] = newValue
            }
        }
    }
}
