import SwiftUI
import WebKit

let processPool = WKProcessPool()

public struct WebView {
    @ObservedObject var page: WebPage
    var request: WebRequest
    
    public init(_ page: WebPage, request: WebRequest) {
        self.page = page
        self.request = request
    }
}

extension WebView: View {
    private var show: Bool {
        page.rendered && page.error == nil
    }
    
    public var body: some View {
        Holder(page: page, request: request)
            .ignoresSafeArea()
            .opacity(show ? 1 : 0.01)
            //progress bar
            .overlay(alignment: .topLeading) {
                ProgressBar(value: page.progress)
            }
            //fix transparent navigation bar background
            .overlay(alignment: .topLeading) {
                Color.white
                    .overlay(
                        .regularMaterial
                        .opacity(show && (page.toolbarBackground == nil || page.prefersHiddenToolbars) ? 1 : 0.01)
                    )
                    .overlay(page.toolbarBackground)
                    .frame(height: 0)
                    .animation(nil, value: page.prefersHiddenToolbars)
            }
            //animation
            .animation(.easeInOut(duration: 0.3), value: show)
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

extension WebView {
    struct Holder: UIViewRepresentable {
        @StateObject private var prev = Prev()

        @ObservedObject var page: WebPage
        var request: WebRequest
        
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
            context.coordinator.load(request)
            prev.request = request
            
            //behaviour
            view.allowsBackForwardNavigationGestures = true
            view.scrollView.contentInsetAdjustmentBehavior = .automatic
            
            return view
        }
        
        func updateUIView(_ view: NativeWebView, context: Context) {
            if prev.request?.url.absoluteURL != request.url.absoluteURL {
                context.coordinator.load(request)
                prev.request = request
            }
        }
        
        class Prev: ObservableObject {
            var request: WebRequest?
        }
    }
}
