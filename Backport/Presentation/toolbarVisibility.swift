import SwiftUI

public extension Backported where Wrapped: View {
    @ViewBuilder func toolbarVisibility(_ visibility: Visibility, for bar: ToolbarPlacement) -> some View {
        if #available(iOS 18, macOS 15, *) {
            content.toolbarVisibility(visibility, for: bar)
        } else {
            content.toolbar(visibility, for: bar)
        }
    }
}
