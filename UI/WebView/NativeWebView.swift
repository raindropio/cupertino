import SwiftUI
import Combine
import WebKit

struct NativeWebView {
    @ObservedObject var service: WebViewService
    var url: URL?
}

#if canImport(UIKit)
extension NativeWebView: UIViewRepresentable {
    public func makeUIView(context: Context) -> WKWebView {
        service.load(url)
        return service.webView
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        service.load(url)
    }
}
#else
extension NativeWebView: NSViewRepresentable {
    public func makeNSView(context: Context) -> WKWebView {
        service.load(url)
        return service.webView
    }
    
    public func updateNSView(_ webView: WKWebView, context: Context) {
        service.load(url)
    }
}
#endif
