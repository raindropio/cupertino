import SwiftUI

public extension View {
    func webViewAdaptColorScheme(_ page: WebPage) -> some View {
        modifier(WebViewAdaptColorScheme(page: page))
    }
}

struct WebViewAdaptColorScheme: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var page: WebPage

    func body(content: Content) -> some View {
        content
            .toolbarBackground(
                page.error == nil && page.colorScheme != nil && page.colorScheme != colorScheme ? .visible : .automatic,
                for: .navigationBar, .bottomBar, .tabBar
            )
            .toolbarColorScheme(
                page.error != nil || page.prefersHiddenToolbars ? nil : page.colorScheme,
                for: .navigationBar, .bottomBar, .tabBar
            )
    }
}
