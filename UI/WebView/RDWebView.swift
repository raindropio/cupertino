import WebKit

/*
 Features:
 - Error state
 - prefersHiddenToolbars state
 - Reuse system cookies
 - Build in refresh control
 - JS window.open, etc just loads as is
 */
class RDWebView: WKWebView {
    @objc dynamic var error: Error?
    @objc dynamic var prefersHiddenToolbars: Bool = false

    private let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        //reuse cookies
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        //init
        super.init(frame: frame, configuration: configuration)
        
        //bindings
        uiDelegate = self
        navigationDelegate = self
        
        //behaviour
        allowsBackForwardNavigationGestures = true
        isOpaque = false
        
        //pull to refresh
        #if canImport(UIKit)
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        #endif
        
        //scroll view
        scrollView.delegate = self
        scrollView.insetsLayoutMarginsFromSafeArea = false
        scrollView.contentInsetAdjustmentBehavior = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
