import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func presentationCompactAdaptation(_ adaptation: BackportPresentationAdaptation) -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            content.presentationCompactAdaptation(adaptation.sui)
        } else {
            content
        }
    }
}

public enum BackportPresentationAdaptation {
    case automatic
    case none
    case popover
    case sheet
    case fullScreenCover
    
    @available(iOS 16.4, macOS 13.3, *)
    var sui: SwiftUI.PresentationAdaptation {
        switch self {
        case .automatic: return .automatic
        case .none: return .none
        case .popover: return .popover
        case .sheet: return .sheet
        case .fullScreenCover: return .fullScreenCover
        }
    }
}
