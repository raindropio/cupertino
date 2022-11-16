import SwiftUI

public extension View {
    func webViewAdaptColorScheme(_ page: WebPage, enabled: Bool = true) -> some View {
        modifier(WebViewAdaptColorScheme(page: page, enabled: enabled))
    }
}

struct WebViewAdaptColorScheme: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var page: WebPage
    var enabled: Bool

    func body(content: Content) -> some View {
        content
            .toolbarBackground(
                enabled && page.error == nil && page.colorScheme != nil && page.colorScheme != colorScheme ? .visible : .automatic,
                for: .navigationBar, .bottomBar, .tabBar
            )
            .toolbarColorScheme(
                !enabled || page.error != nil || page.prefersHiddenToolbars ? nil : page.colorScheme,
                for: .navigationBar, .bottomBar, .tabBar
            )
    }
}
