import SwiftUI

public protocol NavigationPane: Hashable {
    var appearance: NavigationPaneAppearance { get }
}

public extension NavigationPane {
    var appearance: NavigationPaneAppearance { .automatic }
}

public enum NavigationPaneAppearance {
    case automatic
    case fullScreen
}
