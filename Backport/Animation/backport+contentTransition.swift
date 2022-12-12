import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func contentTransition(_ transition: Backport.ContentTransition) -> some View {
        if #available(iOS 16, *) {
            content.contentTransition(transition.convert)
        } else {
            content
        }
    }
}

extension Backport {
    public enum ContentTransition {
        case identity
        case opacity
        case interpolate
        case numericText(countsDown: Bool = false)
        
        @available(iOS 16.0, *)
        var convert: SwiftUI.ContentTransition {
            switch self {
            case .identity: return .identity
            case .opacity: return .opacity
            case .interpolate: return .interpolate
            case .numericText(let countsDown): return .numericText(countsDown: countsDown)
            }
        }
    }
}
