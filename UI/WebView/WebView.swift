import SwiftUI
import WebKit

let processPool = WKProcessPool()

public struct WebView {
    @ObservedObject var page: WebPage
    private var url: URL?
    private var canonical: URL?
    
    public init(_ page: WebPage, url: URL? = nil, canonical: URL? = nil) {
        self.page = page
        self.url = url
        self.canonical = canonical
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
        Holder(page: page, url: url, canonical: canonical)
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
                Color.white
                    .overlay(
                        .regularMaterial
                        .opacity(show && (page.toolbarBackground == nil || page.prefersHiddenToolbars) ? 1 : 0)
                    )
                    .overlay(page.toolbarBackground)
                    .frame(height: 0)
                    .animation(nil, value: page.prefersHiddenToolbars)
            }
            //animation
            .animation(.easeInOut(duration: 0.3), value: show)
            //allow back webview navigation
            .popGesture({
                if page.canGoBack {
                    return .never
                } else if page.prefersHiddenToolbars {
                    return .always
                }
                return .automatic
            }())
    }
}

extension WebView {
    struct Holder: UIViewRepresentable {
        @ObservedObject var page: WebPage
        var url: URL?
        var canonical: URL?
        
        func makeCoordinator() -> WebPage {
            page
        }
        
        func makeUIView(context: Context) -> NativeWebView {
            //configuration
            let configuration = WKWebViewConfiguration()
            configuration.processPool = processPool
            configuration.mediaTypesRequiringUserActionForPlayback = .audio
            
            //reuse cookies
            let cookies = HTTPCookieStorage.shared.cookies ?? []
            for cookie in cookies {
                configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
            
            //create webview
            let view = NativeWebView(frame: .zero, configuration: configuration)
            context.coordinator.view = view
            context.coordinator.canonical = canonical
            context.coordinator.url = url
            
            //behaviour
            view.allowsBackForwardNavigationGestures = true
            view.scrollView.contentInsetAdjustmentBehavior = .automatic
            
            return view
        }
        
        func updateUIView(_ view: NativeWebView, context: Context) {
            if context.coordinator.canonical != canonical {
                context.coordinator.canonical = canonical
            }

            //update url fragment
            if view.url?.fragment != url?.fragment, view.url?.path == url?.path, let string = url?.absoluteString {
                view.evaluateJavaScript("window.location.replace('\(string)'); true")
            }
        }
        
//        static func dismantleUIView(_ view: NativeWebView, coordinator: WebPage) {
//            coordinator.view = nil
//        }
    }
}
