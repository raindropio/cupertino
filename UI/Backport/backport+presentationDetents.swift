import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func presentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        if #available(iOS 16, *) {
            content.presentationDetents(Set(detents.map { $0.native }))
        } else {
            content
        }
    }
}

public extension Backport where Wrapped: View {
    @ViewBuilder func presentationDragIndicator(_ visibility: SwiftUI.Visibility) -> some View {
        if #available(iOS 16, *) {
            content.presentationDragIndicator(visibility)
        } else {
            content
        }
    }
}

extension Backport {
    public enum PresentationDetent: Hashable {
        case medium
        case large
        case fraction(Double)
        case height(Double)
        
        @available(iOS 16.0, *)
        var native: SwiftUI.PresentationDetent {
            switch self {
            case .medium: return .medium
            case .large: return .large
            case .fraction(let fraction): return .fraction(fraction)
            case .height(let height): return .height(height)
            }
        }
    }
}
