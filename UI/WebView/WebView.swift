import SwiftUI
import WebKit

let processPool = WKProcessPool()

public struct WebView {
    @ObservedObject public var page: WebPage
    var request: WebRequest
    var userAgent: String?
    
    public init(_ page: WebPage, request: WebRequest, userAgent: String? = nil) {
        self.page = page
        self.request = request
        self.userAgent = userAgent
    }
}

extension WebView: View {
    public var body: some View {
        Holder(page: page, request: request, userAgent: userAgent)
            .ignoresSafeArea()
            //progress bar
            .overlay(alignment: .topLeading) {
                ProgressBar(value: page.progress)
            }
            //fix transparent navigation bar background
            .overlay(alignment: .topLeading) {
                Color.white
                    .overlay(
                        .regularMaterial
                        .opacity((page.toolbarBackground == nil || page.prefersHiddenToolbars) ? 1 : 0.01)
                    )
                    .overlay(page.toolbarBackground)
                    .frame(height: 0)
                    .animation(nil, value: page.prefersHiddenToolbars)
            }
            //dialogs
            .modifier(Dialogs(page: page))
            //allow back webview navigation
            #if canImport(UIKit)
            .popGesture({
                if page.canGoBack {
                    return .never
                } else if page.prefersHiddenToolbars {
                    return .always
                }
                return .automatic
            }())
            #endif
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
            configuration.processPool = processPool
            configuration.mediaTypesRequiringUserActionForPlayback = .audio
            configuration.applicationNameForUserAgent = userAgent
            
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
