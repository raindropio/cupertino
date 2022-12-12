import WebKit
import Combine

class NativeWebView: WKWebView {
    private var cancelables = Set<AnyCancellable>()

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        //reuse cookies
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies {
            configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        //init
        super.init(frame: frame, configuration: configuration)
        
        //pull to refresh
        #if canImport(UIKit)
        scrollView.refreshControl = .init()
        scrollView.refreshControl?.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        
        publisher(for: \.underPageBackgroundColor)
            .sink { [weak self] in self?.scrollView.refreshControl?.overrideUserInterfaceStyle = ($0?.isLight ?? true) ? .light : .dark }
            .store(in: &cancelables)
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
