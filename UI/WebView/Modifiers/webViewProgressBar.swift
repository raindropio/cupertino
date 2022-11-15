import SwiftUI

public extension View {
    func webViewProgressBar(_ page: WebPage) -> some View {
        modifier(WebViewProgressBar(page: page))
    }
}

struct WebViewProgressBar: ViewModifier {
    @ObservedObject var page: WebPage

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                ProgressView(value: page.progress)
                    .progressViewStyle(.simpleHorizontal)
                    .opacity(page.isLoading ? 1 : 0)
                    .animation(.default.delay(0.3), value: page.isLoading)
            }
    }
}
