import SwiftUI

public extension Backported where Wrapped: View {
    @ViewBuilder func contentMargins(_ length: CGFloat) -> some View {
        if #available(iOS 18, macOS 15, *) {
            content.contentMargins(length)
        } else {
            content
        }
    }
}
