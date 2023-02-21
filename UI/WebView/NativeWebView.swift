import WebKit
import Combine

class NativeWebView: WKWebView {
    private var cancelables = Set<AnyCancellable>()

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        //init
        super.init(frame: frame, configuration: configuration)
        
        //pull to refresh
        #if canImport(UIKit)
        scrollView.refreshControl = .init()
        scrollView.refreshControl?.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        
        //fix refresh control color-scheme
        publisher(for: \.underPageBackgroundColor)
            .sink { [weak self] in self?.scrollView.refreshControl?.overrideUserInterfaceStyle = ($0?.isLight ?? true) ? .light : .dark }
            .store(in: &cancelables)
        
        //fix white background flash
        publisher(for: \.estimatedProgress)
            .sink { [weak self] in
                let isOpaque = $0 >= 0.4 || (self?.canGoBack == true)
                if isOpaque != self?.isOpaque {
                    self?.isOpaque = isOpaque
                }
            }
            .store(in: &cancelables)
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
