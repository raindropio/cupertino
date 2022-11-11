import SwiftUI

#if os(macOS)
public enum UserInterfaceSizeClass {
    case regular
    case compact
}

public struct HorizontalSizeClassKey: EnvironmentKey {
    public static let defaultValue : UserInterfaceSizeClass = .regular
}

public extension EnvironmentValues {
  var horizontalSizeClass: UserInterfaceSizeClass {
    get { self[HorizontalSizeClassKey.self] }
    set {
        if self[HorizontalSizeClassKey.self] != newValue {
            self[HorizontalSizeClassKey.self] = newValue
        }
    }
  }
}

public struct VerticalSizeClassKey: EnvironmentKey {
    public static let defaultValue : UserInterfaceSizeClass = .regular
}

public extension EnvironmentValues {
  var verticalSizeClass: UserInterfaceSizeClass {
    get { self[VerticalSizeClassKey.self] }
    set {
        if self[VerticalSizeClassKey.self] != newValue {
            self[VerticalSizeClassKey.self] = newValue
        }
    }
  }
}
#endif
