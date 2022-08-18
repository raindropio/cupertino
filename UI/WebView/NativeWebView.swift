import SwiftUI
import Combine
import WebKit

struct NativeWebView {
    @ObservedObject var service: WebViewService
    var url: URL?
}

extension NativeWebView: UIViewRepresentable {
    public func makeUIView(context: Context) -> WKWebView {
        service.load(url)
        return service.webView
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        service.load(url)
    }
}
