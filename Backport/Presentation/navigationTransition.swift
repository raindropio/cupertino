import SwiftUI

public extension Backported where Wrapped: View {
    @ViewBuilder func navigationTransition(_ style: BackportNavigationTransition) -> some View {
        if #available(iOS 18, macOS 15, *) {
            content.navigationTransition(style.sui)
        } else {
            content
        }
    }
}

public enum BackportNavigationTransition {
    case automatic
    case zoom(sourceID: any Hashable, in: Namespace.ID)
    
    @available(iOS 18, macOS 15, *)
    var sui: SwiftUI.NavigationTransition {
        switch self {
        case .automatic: return .automatic
        case .zoom(let sourceID, let namespace): return .zoom(sourceID: sourceID, in: namespace)
        }
    }
}
