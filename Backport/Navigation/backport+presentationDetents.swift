import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func presentationDetents(_ detents: Set<BackportPresentationDetent>) -> some View {
        if #available(iOS 16, *) {
            content.presentationDetents(Set(detents.map { $0.native }))
        } else {
            content
        }
    }
    
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func presentationDetents(_ detents: Set<BackportPresentationDetent>, selection: Binding<BackportPresentationDetent>) -> some View {
        if #available(iOS 16, *) {
            content.presentationDetents(
                Set(detents.map { $0.native }),
                selection: .init {
                    selection.wrappedValue.native
                } set: {
                    selection.wrappedValue = $0.backport
                }
            )
        } else {
            content
        }
    }
}

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func presentationDragIndicator(_ visibility: SwiftUI.Visibility) -> some View {
        if #available(iOS 16, *) {
            content.presentationDragIndicator(visibility)
        } else {
            content
        }
    }
}

@available(iOS, deprecated: 16.0)
public enum BackportPresentationDetent: Hashable {
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

@available(iOS 16.0, *)
extension PresentationDetent {
    var backport: BackportPresentationDetent {
        switch self {
        case .medium: return .medium
        default: return .large
        }
    }
}
