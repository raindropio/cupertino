import SwiftUI
import WebKit

public class WebPage: NSObject, ObservableObject {
    weak var view: WKWebView? {
        didSet {
            oldValue?.navigationDelegate = nil
            oldValue?.uiDelegate = nil
            oldValue?.scrollView.delegate = nil
            view?.navigationDelegate = self
            view?.uiDelegate = self
            view?.scrollView.delegate = self
        }
    }
    
    @Published public var wait = true
    @Published public var progress: Double = 0
    @Published public var error: Error?
    @Published public var title: String?
    @Published public var current: URL?
    @Published public var canGoBack = false
    @Published public var canGoForward = false
    @Published public var prefersHiddenToolbars = false

    func load(_ url: URL?) {
        Task {
            await MainActor.run {
                self.wait = true
            }
        }
        view?.load(.init(url: url ?? URL(string: "about:blank")!))
    }
    
    @MainActor
    func changed() {
        current = view?.url
        
        //title
        if let title = view?.title, (!title.isEmpty || error != nil) {
            self.title = title
        }
        
        //navigation
        progress = view?.estimatedProgress ?? 0
        canGoBack = view?.canGoBack ?? false
        canGoForward = view?.canGoForward ?? false
        
        //page color
        let pageStyle: UIUserInterfaceStyle = (view?.underPageBackgroundColor.isLight ?? false) ? .light : .dark
        
        //refresh control
        view?.scrollView.refreshControl?.overrideUserInterfaceStyle = pageStyle
        if view?.isLoading == false {
            view?.scrollView.refreshControl?.endRefreshing()
        }
        
        //hidden toolbars
        if ((view?.scrollView.contentOffset.y ?? 0) <= 0), prefersHiddenToolbars == true {
            prefersHiddenToolbars = false
        }
        
        //fix white splash
        if wait {
            let hidden = !(view?.canGoBack ?? false) && (view?.estimatedProgress ?? 0) < 0.5
            if !hidden {
                wait = false
            }
        }
    }
}
