import SwiftUI

private struct SplitViewSizeClassKey: EnvironmentKey {
    static let defaultValue: UserInterfaceSizeClass? = nil
}

public extension EnvironmentValues {
    var splitViewSizeClass: UserInterfaceSizeClass? {
        get {
            self[SplitViewSizeClassKey.self]
        }
        set {
            if self[SplitViewSizeClassKey.self] != newValue {
                self[SplitViewSizeClassKey.self] = newValue
            }
        }
    }
}
