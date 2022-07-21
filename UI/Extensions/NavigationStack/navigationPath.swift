import SwiftUI

@available(iOS 16.0, *)
@available(macOS 13.0, *)
private struct NavigationStackPathKey: EnvironmentKey {
    static let defaultValue : Binding<NavigationPath>? = nil
}


public extension EnvironmentValues {
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    var navigationPath: Binding<NavigationPath>? {
        get { self[NavigationStackPathKey.self] }
        set { self[NavigationStackPathKey.self] = newValue }
    }
}
