import SwiftUI
import WebKit
import Combine

public class WebPage: NSObject, ObservableObject {
    private var cancellable: AnyCancellable?
    private var history: [URL : WebRequest] = [:]
    
    weak var view: WKWebView? {
        didSet {
            guard oldValue != view else { return }
            
            oldValue?.navigationDelegate = nil
            oldValue?.uiDelegate = nil
            oldValue?.scrollView.delegate = nil
            
            history = .init()
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
                    view.publisher(for: \.underPageBackgroundColor).removeDuplicates().map({ _ in }).eraseToAnyPublisher(),
                    view.backForwardList.publisher(for: \.currentItem).removeDuplicates().map({ _ in }).eraseToAnyPublisher()
                )
                    .sink(receiveValue: changed)
            }
        }
    }
    
    @MainActor
    public func load(_ request: WebRequest) {
        guard self.request != request else { return }
                
        //update url fragment only
        if self.request?.url.fragment != request.url.fragment, self.request?.url.path == request.url.path {
            view?.evaluateJavaScript("window.location.replace('\(request.url.absoluteString)'); true")
        }
        //full reload
        else {
            view?.load(request.urlRequest)
            history[request.url.absoluteURL] = request
            changed()
        }
    }
    
    public var url: URL? {
        request?.canonical ?? request?.url ?? view?.url
    }
    
    public var request: WebRequest? {
        guard let initialURL = view?.backForwardList.currentItem?.initialURL
        else { return history.first?.value }
        return history[initialURL]
    }
    
    @Published public var error: Error?
    @Published public var prefersHiddenToolbars = false
    
    //dialogs
    @Published var alert: Alert?
    @Published var confirm: Confirm?
    @Published var prompt: Prompt?

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
        //TODO: better logic (for next page navigation)
        canGoBack || canGoForward || progress >= 0.5
    }
    public var colorScheme: ColorScheme {
        view?.underPageBackgroundColor.isLight == true ? .light : .dark
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
    
    @MainActor
    public func evaluateJavaScript(_ string: String) async throws { try await view?.evaluateJavaScript(string) }
}

extension WebPage {
    struct Alert {
        var title: String?
        var message: String = ""
        var callback: () -> Void
    }
    
    struct Confirm {
        var title: String?
        var message: String = ""
        var callback: (Bool) -> Void
    }
    
    struct Prompt {
        var title: String?
        var message: String = ""
        var defaultValue: String?
        var callback: (String?) -> Void
    }
}
