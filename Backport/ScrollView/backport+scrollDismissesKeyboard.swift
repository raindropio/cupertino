import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder
    func scrollDismissesKeyboard(_ mode: Backport.ScrollDismissesKeyboardMode) -> some View {
        if #available(iOS 16, *) {
            content.scrollDismissesKeyboard(mode.converted)
        } else {
            content
        }
    }
}

extension Backport {
    public enum ScrollDismissesKeyboardMode {
        case automatic
        case immediately
        case interactively
        case never
        
        @available(iOS 16.0, *)
        var converted: SwiftUI.ScrollDismissesKeyboardMode {
            switch self {
            case .automatic: return .automatic
            case .immediately: return .immediately
            case .interactively: return .interactively
            case .never: return .never
            }
        }
    }
}
