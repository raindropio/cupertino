import SwiftUI

public extension Backported where Wrapped: ToolbarContent {
    @ToolbarContentBuilder
    func matchedTransitionSource(id: some Hashable, in namespace: Namespace.ID) -> some ToolbarContent {
        if #available(iOS 26, macOS 26, *) {
            content.matchedTransitionSource(id: id, in: namespace)
        } else {
            content
        }
    }
}
