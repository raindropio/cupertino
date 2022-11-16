import SwiftUI

public struct WebView {
    @ObservedObject var page: WebPage
    var url: URL?
    
    public init(_ page: WebPage, url: URL? = nil) {
        self.page = page
        self.url = url
    }
}

extension WebView: View {
    public var body: some View {
        Proxy(page: page)
//            .ignoresSafeArea()
            .ignoresSafeArea(.container, edges: .all)
            .task(id: url) { page.url = url }
    }
}

extension WebView {
    struct Proxy: UIViewRepresentable {
        @ObservedObject var page: WebPage
        
        public func makeUIView(context: Context) -> RDWebView {
            page.webView
        }
        
        public func updateUIView(_ webView: RDWebView, context: Context) {}
    }
}
