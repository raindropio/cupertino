import SwiftUI

public extension View {
    func webViewHidesBarsOnSwipe(_ page: WebPage, enabled: Bool = true) -> some View {
        modifier(WebViewHidesBarsOnSwipe(page: page, enabled: enabled))
    }
}

struct WebViewHidesBarsOnSwipe: ViewModifier {
    @ObservedObject var page: WebPage
    var enabled: Bool

    func body(content: Content) -> some View {
        let hide = enabled && page.prefersHiddenToolbars
        
        content
            .toolbar(hide ? .hidden : .automatic, for: .navigationBar, .bottomBar, .tabBar)
            .animation(.default, value: hide)
            .overlay(alignment: .topLeading) {
                if enabled {
                    Color(page.underPageBackgroundColor)
                        .overlay(.bar)
                        .frame(height: 0)
                        .opacity(hide ? 1 : 0)
                }
            }
    }
}
