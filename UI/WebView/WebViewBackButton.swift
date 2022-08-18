import SwiftUI

public struct WebViewBackButton {
    @ObservedObject var service: WebViewService
    
    public init(_ service: WebViewService) {
        self.service = service
    }
}

extension WebViewBackButton: View {
    public var body: some View {
        Button {
            service.webView.goBack()
        } label: {
            Image(systemName: "chevron.left")
        }
            .disabled(!service.canGoBack)
    }
}
