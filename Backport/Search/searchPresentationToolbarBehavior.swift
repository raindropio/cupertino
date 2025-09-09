import SwiftUI

public extension Backported where Wrapped: View {
    @ViewBuilder func searchPresentationToolbarBehavior(_ behavior: BackportSearchPresentationToolbarBehavior) -> some View {
        if #available(iOS 17.1, macOS 14.1, *) {
            content.searchPresentationToolbarBehavior(behavior.sui)
        } else {
            content
        }
    }
}

public enum BackportSearchPresentationToolbarBehavior {
    case automatic
    case avoidHidingContent
    
    @available(iOS 17.1, macOS 14.1, *)
    var sui: SwiftUI.SearchPresentationToolbarBehavior {
        switch self {
        case .automatic: return .automatic
        case .avoidHidingContent: return .avoidHidingContent
        }
    }
}
