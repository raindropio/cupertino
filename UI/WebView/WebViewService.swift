import SwiftUI
import Combine
import WebKit

@dynamicMemberLookup
public class WebViewService: NSObject, ObservableObject, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    @Published public var prefersHiddenToolbars: Bool = false
    
    private var observers: [NSKeyValueObservation] = []
    public var webView: WKWebView
    public var refreshControl: UIRefreshControl
    
    private var startingUrl: URL?
    
    public override init() {
        webView = .init()
        refreshControl = .init()
        super.init()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        //appearance
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        webView.scrollView.delegate = self
        setTransparent(true)
        
        //reuse cookies
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        //pull to refresh
        webView.scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        
        //observe changes
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward),
            subscriber(for: \.underPageBackgroundColor)
        ]
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
    
    #if canImport(UIKit)
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        webView.reload()
    }
    #endif
    
    private func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
        webView.observe(keyPath) { [weak self] _, _ in
            self?.objectWillChange.send()
        }
    }
    
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
    
    //start loading
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    //getting data
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        setTransparent(false)
    }
    
    //end loading
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshControl.endRefreshing()
    }
    
    //error loading
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        setTransparent(false)
    }
    
    //window.open, etc
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
}
