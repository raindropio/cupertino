import SwiftUI

public struct WebViewForwardButton {
    @ObservedObject var service: WebViewService
    
    public init(_ service: WebViewService) {
        self.service = service
    }
}

extension WebViewForwardButton: View {
    public var body: some View {
        Button {
            service.webView.goForward()
        } label: {
            Image(systemName: "chevron.right")
        }
            .disabled(!service.canGoForward)
    }
}
