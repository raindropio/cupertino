import SwiftUI
import WebKit
import Combine

public class WebPage: NSObject, ObservableObject {
    private var cancellable: AnyCancellable?
    
    weak var view: WKWebView? {
        didSet {
            guard oldValue != view else { return }
            
            oldValue?.navigationDelegate = nil
            oldValue?.uiDelegate = nil
            oldValue?.scrollView.delegate = nil
            
            cancellable = nil
            if let view {
                view.navigationDelegate = self
                view.uiDelegate = self
                view.scrollView.delegate = self
                
                cancellable = Publishers.MergeMany(
                    view.publisher(for: \.estimatedProgress).removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
                    view.publisher(for: \.isLoading).removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
                    view.publisher(for: \.canGoBack).removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
                    view.publisher(for: \.canGoForward).removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
                    view.publisher(for: \.title).removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
                    view.publisher(for: \.underPageBackgroundColor).removeDuplicates().map({ _ in }).eraseToAnyPublisher()
                )
                    .sink(receiveValue: changed)
            }
        }
    }
    
    public var url: URL? {
        get {
            view?.url
        }
        set {
            guard newValue != url else { return }
            view?.load(.init(
                url: newValue ?? URL(string: "about:blank")!,
                cachePolicy: .reloadRevalidatingCacheData
            ))
        }
    }
    
    @Published public var error: Error?
    @Published public var prefersHiddenToolbars = false
    
    private func changed() {
        Task {
            await MainActor.run {
                objectWillChange.send()
            }
        }
    }
}

extension WebPage {
    public var progress: Double { view?.estimatedProgress ?? 0 }
    public var canGoBack: Bool { view?.canGoBack ?? false }
    public var canGoForward: Bool { view?.canGoForward ?? false }
    public var title: String? { view?.title }
    public var rendered: Bool {
        //TODO: better logic
        canGoBack || canGoForward || progress >= 0.5
    }
    public var toolbarBackground: Color? {
        guard let color = view?.underPageBackgroundColor, let viewStyle = view?.traitCollection.userInterfaceStyle else { return nil }
        let pageStyle: UIUserInterfaceStyle = color.isLight ? .light : .dark
        guard viewStyle == pageStyle else { return nil }
        return Color(color)
    }
    
    public func reload() { view?.reload() }
    public func goBack() { view?.goBack() }
    public func goForward() { view?.goForward() }
}
