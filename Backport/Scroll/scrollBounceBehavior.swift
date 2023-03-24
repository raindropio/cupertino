import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func scrollBounceBehavior(_ behavior: BackportScrollBounceBehavior, axes: Axis.Set = [.vertical]) -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            content.scrollBounceBehavior(behavior.sui, axes: axes)
        } else {
            content
        }
    }
}

public enum BackportScrollBounceBehavior {
    case automatic
    case always
    case basedOnSize
    
    @available(iOS 16.4, *)
    var sui: SwiftUI.ScrollBounceBehavior {
        switch self {
        case .automatic: return .automatic
        case .always: return .always
        case .basedOnSize: return .basedOnSize
        }
    }
}
