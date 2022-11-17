import WebKit
import Combine

/*
 Features:
 - Error state
 - prefersHiddenToolbars state
 - Reuse system cookies
 - Build in refresh control
 - JS window.open, etc just loads as is
 */
class RDWebView: WKWebView {
    private var cancelables = Set<AnyCancellable>()
    
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
        publisher(for: \.underPageBackgroundColor)
            .sink { [weak self] in self?.refreshControl.overrideUserInterfaceStyle = ($0?.isLight ?? true) ? .light : .dark }
            .store(in: &cancelables)
        #endif
        
        //scroll view
        scrollView.delegate = self
        scrollView.insetsLayoutMarginsFromSafeArea = false
        scrollView.contentInsetAdjustmentBehavior = .always
        
        //end loading
        publisher(for: \.isLoading)
            .dropFirst()
            .filter { !$0 }
            .sink { [weak self] _ in
                #if canImport(UIKit)
                self?.refreshControl.endRefreshing()
                #endif
                
                if ((self?.scrollView.contentOffset.y ?? 0) <= 0), self?.prefersHiddenToolbars == true {
                    self?.prefersHiddenToolbars = false
                }
            }
            .store(in: &cancelables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
