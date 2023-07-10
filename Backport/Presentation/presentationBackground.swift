import SwiftUI

public extension Backport where Wrapped: View {
    @ViewBuilder func presentationBackground<S: ShapeStyle>(_ style: S) -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            content.presentationBackground(style)
        } else {
            content
        }
    }
    
    @ViewBuilder func presentationBackground<V: View>(alignment: Alignment = .center, @ViewBuilder content bgContent: () -> V) -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            content.presentationBackground(alignment: alignment, content: bgContent)
        } else {
            content
        }
    }
}
