import SwiftUI

public extension View {
    func webViewError(_ page: WebPage) -> some View {
        modifier(WebViewError(page: page))
    }
}

struct WebViewError: ViewModifier {
    @ObservedObject var page: WebPage

    func body(content: Content) -> some View {
        content
            .overlay {
                Group {
                    if let error = page.error {
                        EmptyState("Error", message: error.localizedDescription) {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundStyle(.yellow)
                        } actions: {
                            Button(action: page.reload) {
                                Label("Reload", systemImage: "arrow.clockwise")
                            }
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.background)
                            .transition(.opacity)
                    }
                }
            }
            .animation(.default, value: page.error != nil)
    }
}
