import SwiftUI

private struct NavigationStackPathKey: EnvironmentKey {
    static let defaultValue : Binding<NavigationPath>? = nil
}

public extension EnvironmentValues {
  var navigationPath: Binding<NavigationPath>? {
    get { self[NavigationStackPathKey.self] }
    set { self[NavigationStackPathKey.self] = newValue }
  }
}
