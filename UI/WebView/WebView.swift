import SwiftUI
import WebKit
import Backport

public struct WebView {
    @ObservedObject public var page: WebPage
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var request: WebRequest
    var userAgent: String?
    
    public init(_ page: WebPage, request: WebRequest, userAgent: String? = nil) {
        self.page = page
        self.request = request
        self.userAgent = userAgent
    }
}

extension WebView: View {
    private var ignoreEdges: Edge.Set {
        if #available(iOS 24.0, *) {
            return .bottom
        }
        return page.prefersHiddenToolbars ? .bottom : []
    }
    
    public var body: some View {
        ZStack {
            page.toolbarBackground
                .ignoresSafeArea()
            
            Holder(page: page, request: request, userAgent: userAgent)
                .ignoresSafeArea(.all, edges: ignoreEdges)
                //progress bar
                .overlay(alignment: .topLeading) {
                    ProgressBar(value: page.progress)
                }
                //dialogs
                .modifier(Dialogs(page: page))
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
}

extension WebView {
    struct Holder {
        @StateObject private var prev = Prev()

        @ObservedObject var page: WebPage
        var request: WebRequest
        var userAgent: String?
                
        class Prev: ObservableObject {
            var request: WebRequest?
        }
        
        func makeView(context: Context) -> NativeWebView {
            //configuration
            let configuration = WKWebViewConfiguration()
            configuration.mediaTypesRequiringUserActionForPlayback = []
            configuration.applicationNameForUserAgent = userAgent
            configuration.allowsInlineMediaPlayback = true
            
            //reuse cookies
            let cookies = HTTPCookieStorage.shared.cookies ?? []
            for cookie in cookies {
                configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
            
            //create webview
            let view = NativeWebView(frame: .zero, configuration: configuration)
            context.coordinator.view = view
            context.coordinator.load(request)
            prev.request = request
            
            //behaviour
            view.allowsBackForwardNavigationGestures = true
            #if canImport(UIKit)
            view.scrollView.contentInsetAdjustmentBehavior = .automatic
            #endif
            
            return view
        }
        
        func updateView(_ view: NativeWebView, context: Context) {
            if prev.request?.url.absoluteURL != request.url.absoluteURL {
                context.coordinator.load(request)
                prev.request = request
            }
        }
    }
}

#if canImport(UIKit)
extension WebView.Holder: UIViewRepresentable {
    func makeCoordinator() -> WebPage {
        page
    }
    
    func makeUIView(context: Context) -> NativeWebView {
        makeView(context: context)
    }
    
    func updateUIView(_ view: NativeWebView, context: Context) {
        updateView(view, context: context)
    }
}
#else
extension WebView.Holder: NSViewRepresentable {
    func makeCoordinator() -> WebPage {
        page
    }
    
    func makeNSView(context: Context) -> NativeWebView {
        makeView(context: context)
    }
    
    func updateNSView(_ view: NativeWebView, context: Context) {
        updateView(view, context: context)
    }
}
#endif
