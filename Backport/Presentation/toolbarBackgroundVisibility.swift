import SwiftUI

public extension Backported where Wrapped: View {
    @ViewBuilder func toolbarBackgroundVisibility(_ visibility: Visibility, for bar: ToolbarPlacement) -> some View {
        if #available(iOS 18, macOS 15, *) {
            content.toolbarBackgroundVisibility(visibility, for: bar)
        } else {
            content
        }
    }
}
