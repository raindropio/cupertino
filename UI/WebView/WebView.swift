import SwiftUI
import WebKit

public struct WebView {
    @ObservedObject var page: WebPage
    private var url: URL?
    
    public init(_ page: WebPage, url: URL? = nil) {
        self.page = page
        self.url = url
    }
}

extension WebView: View {
    private var id: String {
        guard let url else { return "" }
        return "\(url.host ?? "")\(url.path)"
    }
    
    private var show: Bool {
        page.rendered && page.error == nil
    }
    
    public var body: some View {
        Holder(page: page, url: url)
            //recreate webview when url change (fragment is ignored)
            .id(id)
            .ignoresSafeArea()
            .opacity(show ? 1 : 0)
            //progress bar
            .overlay(alignment: .topLeading) {
                ProgressBar(value: page.progress)
            }
            //fix transparent navigation bar background
            .overlay(alignment: .topLeading) {
                Color.clear.overlay(.thickMaterial).overlay(.background.opacity(0.4)).frame(height: 0)
                    .opacity(show ? 1 : 0)
            }
            //animation
            .animation(.default, value: show)
            //allow back webview navigation
            .popGesture(!page.canGoBack)
    }
}

extension WebView {
    struct Holder: UIViewRepresentable {
        @ObservedObject var page: WebPage
        var url: URL?
        
        func makeCoordinator() -> WebPage {
            page
        }
        
        func makeUIView(context: Context) -> NativeWebView {
            //create webview
            let view = NativeWebView()
            context.coordinator.view = view
            context.coordinator.url = url
            
            //behaviour
            view.allowsBackForwardNavigationGestures = true
            view.scrollView.insetsLayoutMarginsFromSafeArea = false
            view.scrollView.contentInsetAdjustmentBehavior = .always
            
            return view
        }
        
        func updateUIView(_ view: NativeWebView, context: Context) {
            //update url fragment
            if view.url?.fragment != url?.fragment, view.url?.path == url?.path {
                Task {
                    try? await view.evaluateJavaScript("location.hash=\"\(url?.fragment ?? "")\"")
                }
            }
        }
        
//        static func dismantleUIView(_ view: NativeWebView, coordinator: WebPage) {
//            coordinator.view = nil
//        }
    }
}
