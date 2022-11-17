import SwiftUI

public extension View {
    func webViewHidesBarsOnSwipe(_ page: WebPage) -> some View {
        modifier(WebViewHidesBarsOnSwipe(page: page))
    }
}

struct WebViewHidesBarsOnSwipe: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var page: WebPage

    func body(content: Content) -> some View {
        content
            .toolbarBackground(
                page.colorScheme != nil && page.colorScheme != colorScheme ? .visible : .automatic,
                for: .navigationBar, .bottomBar, .tabBar
            )
            .toolbar(
                page.prefersHiddenToolbars ? .hidden : .automatic,
                for: .navigationBar, .bottomBar, .tabBar
            )
            .animation(.default, value: page.prefersHiddenToolbars)
            .overlay(alignment: .topLeading) {
                Color(page.underPageBackgroundColor)
                    .overlay(.bar)
                    .frame(height: 0)
                    .opacity(page.prefersHiddenToolbars ? 1 : 0)
            }
    }
}
