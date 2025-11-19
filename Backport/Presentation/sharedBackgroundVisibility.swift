import SwiftUI

public extension Backported where Wrapped: ToolbarContent {
    @ToolbarContentBuilder
    func sharedBackgroundVisibility(_ visibility: Visibility) -> some ToolbarContent {
        if #available(iOS 26, macOS 26, *) {
            content.sharedBackgroundVisibility(visibility)
        } else {
            content
        }
    }
}
