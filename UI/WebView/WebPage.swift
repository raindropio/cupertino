import SwiftUI

public class WebPage: ObservableObject {
    let webView = RDWebView()
    
    @Published private var _url: URL?
    public var url: URL? {
        get { _url }
        set {
            webView.load(.init(url: newValue ?? .init(string: "about:blank")!))
        }
    }
    
    //nav
    @Published public var isLoading = false
    @Published public var progress: Double = 0
    @Published public var error: Error?
    @Published public var canGoBack = false
    @Published public var canGoForward = false
    
    //some
    @Published public var title: String?
    
    //appearance
    @Published public var prefersHiddenToolbars = false
    @Published public var underPageBackgroundColor: UIColor = .clear
    
    public var colorScheme: ColorScheme? {
        guard painted else { return nil }
        return underPageBackgroundColor.isLight ? ColorScheme.light : ColorScheme.dark
    }
    
    public var painted: Bool {
        webView.canGoBack || webView.canGoForward ||
        progress >= 0.5
    }
    
    public init() {
        webView.publisher(for: \.url)
            .assign(to: &$_url)
        
        webView.publisher(for: \.isLoading)
            .assign(to: &$isLoading)
        
        webView.publisher(for: \.estimatedProgress)
            .assign(to: &$progress)
        
        webView.publisher(for: \.error)
            .assign(to: &$error)
        
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)
        
        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)
        
        webView.publisher(for: \.title)
            .assign(to: &$title)
        
        webView.publisher(for: \.prefersHiddenToolbars)
            .assign(to: &$prefersHiddenToolbars)
        
        webView.publisher(for: \.underPageBackgroundColor)
            .assign(to: &$underPageBackgroundColor)
    }
    
    public func reload() {
        webView.reload()
    }
    
    public func goBack() {
        webView.goBack()
    }
    
    public func goForward() {
        webView.goForward()
    }
}
