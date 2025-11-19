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
        #endif
        
//        scrollView.contentInsetAdjustmentBehavior = .never
//        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
//        scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
//        scrollView.scrollIndicatorInsets = .init(top: 128, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancelables.forEach { $0.cancel() }
    }
}
