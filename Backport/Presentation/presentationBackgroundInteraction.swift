import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func presentationBackgroundInteraction(_ interaction: BackportPresentationBackgroundInteraction) -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            content.presentationBackgroundInteraction(interaction.sui)
        } else {
            content
        }
    }
}

public enum BackportPresentationBackgroundInteraction {
    case automatic
    case enabled
    case disabled
    
    @available(iOS 16.4, *)
    var sui: SwiftUI.PresentationBackgroundInteraction {
        switch self {
        case .automatic: return .automatic
        case .enabled: return .enabled
        case .disabled: return .disabled
        }
    }
}
