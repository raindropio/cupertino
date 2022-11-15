import SwiftUI

public extension View {
    func webViewHidesBarsOnSwipe(_ page: WebPage) -> some View {
        modifier(WebViewHidesBarsOnSwipe(page: page))
    }
}

struct WebViewHidesBarsOnSwipe: ViewModifier {
    @ObservedObject var page: WebPage

    func body(content: Content) -> some View {
        content
            .toolbar(page.prefersHiddenToolbars ? .hidden : .automatic, for: .navigationBar, .bottomBar, .tabBar)
            .animation(.default, value: page.prefersHiddenToolbars)
            .overlay(alignment: .topLeading) {
                Color(page.underPageBackgroundColor)
                    .overlay(.bar)
                    .frame(height: 0)
                    .opacity(page.prefersHiddenToolbars ? 1 : 0)
            }
    }
}
