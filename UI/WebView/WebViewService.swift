import SwiftUI
import Combine
import WebKit

@dynamicMemberLookup
public class WebViewService: NSObject, ObservableObject, WKNavigationDelegate, WKUIDelegate {
    private var cancellables = Set<AnyCancellable>()
    private var startingUrl: URL?

    @Published public var error: Error?
    @Published public var prefersHiddenToolbars: Bool = false
    public var webView: WKWebView
    
    #if canImport(UIKit)
    public var refreshControl: UIRefreshControl
    #endif
    
    public override init() {
        webView = .init()
        #if canImport(UIKit)
        refreshControl = .init()
        #endif
        super.init()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        //appearance
        webView.allowsBackForwardNavigationGestures = true
        #if canImport(UIKit)
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        webView.scrollView.delegate = self
        #endif
        setTransparent(true)
        
        //reuse cookies
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        //pull to refresh
        #if canImport(UIKit)
        webView.scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        #endif
        
        //observe changes
        Publishers.MergeMany([
            webView.url.publisher.map({ _ in }).eraseToAnyPublisher(),
            webView.themeColor.publisher.map({ _ in }).eraseToAnyPublisher(),
            webView.underPageBackgroundColor.publisher.map({ _ in }).eraseToAnyPublisher(),
            webView.publisher(for: \.estimatedProgress).map({ _ in }).eraseToAnyPublisher(),
            webView.publisher(for: \.isLoading).map({ _ in }).eraseToAnyPublisher(),
            webView.publisher(for: \.backForwardList).map({ _ in }).eraseToAnyPublisher()
        ])
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.webViewChanged() }
            .store(in: &cancellables)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
        webView[keyPath: keyPath]
    }
    
    public func load(_ url: URL?) {
        if startingUrl != url {
            startingUrl = url
            _ = webView.load(
                .init(url: url ?? .init(string: "about:blank")!)
            )
        }
    }
    
    //MARK: - Private methods
    private func webViewChanged() {
        objectWillChange.send()
        #if canImport(UIKit)
        refreshControl.tintColor = webView.underPageBackgroundColor.isLight ? .lightGray : .white
        #endif
    }
    
    #if canImport(UIKit)
    @objc private func reloadWebView(_ sender: UIRefreshControl) {
        webView.reload()
    }
    #endif
    
    private func setTransparent(_ transparent: Bool, _ withAnimation: Bool = false) {
        #if canImport(UIKit)
        webView.isOpaque = !transparent
        
        if withAnimation {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.webView.layer.opacity = transparent ? 0 : 1
            }
        } else {
            webView.layer.opacity = transparent ? 0 : 1
        }
        #else
        webView.setValue(!transparent, forKey: "drawsBackground")
        webView.layer?.opacity = transparent ? 0 : 1
        #endif
    }
    
    //MARK: - WebView Delegate
    //start loading
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.error = nil
    }
    
    //getting data
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        setTransparent(false)
    }
    
    //end loading
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.error = nil
        
        #if canImport(UIKit)
        refreshControl.endRefreshing()
        
        if webView.scrollView.contentOffset.y <= 0 && prefersHiddenToolbars {
            prefersHiddenToolbars = false
        }
        #endif
    }
    
    //error loading
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.error = error
        setTransparent(false)
        
        #if canImport(UIKit)
        refreshControl.endRefreshing()

        if webView.scrollView.contentOffset.y <= 0 && prefersHiddenToolbars {
            prefersHiddenToolbars = false
        }
        #endif
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        setTransparent(false)
        self.error = error
        
        #if canImport(UIKit)
        refreshControl.endRefreshing()
        #endif
    }
    
    //window.open, etc
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
}

#if canImport(UIKit)
extension WebViewService: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let oldY = scrollView.contentOffset.y
        let newY = targetContentOffset.pointee.y
        
        if newY == oldY {
        } else if newY > oldY, newY > scrollView.frame.height / 2 {
            if !prefersHiddenToolbars {
                prefersHiddenToolbars = true
            }
        } else {
            if prefersHiddenToolbars {
                prefersHiddenToolbars = false
            }
        }
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        prefersHiddenToolbars = false
        return true
    }
}
#endif
