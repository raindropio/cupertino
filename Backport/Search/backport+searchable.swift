import SwiftUI
import Combine

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func searchable<C: RandomAccessCollection & RangeReplaceableCollection, T: View, S: View>(
        text: Binding<String>,
        tokens: Binding<C>,
        placement: SearchFieldPlacement = .automatic,
        prompt: Text? = nil,
        token: @escaping (C.Element) -> T,
        @ViewBuilder suggestions: () -> S
    ) -> some View where C.Element : Identifiable {
        if #available(iOS 16, *) {
            content
                .searchable(text: text, tokens: tokens, placement: placement, prompt: prompt, token: token)
                .searchSuggestions(suggestions)
        } else {
            content
                .searchable(text: text, placement: .navigationBarDrawer, prompt: prompt, suggestions: suggestions)
                .modifier(SearchableTokens(text: text, tokens: tokens))
        }
    }
}

fileprivate struct SearchableTokens<T: RandomAccessCollection & RangeReplaceableCollection>: ViewModifier where T.Element: Identifiable {
    @StateObject private var service = CompletionService()
    @Binding var text: String
    @Binding var tokens: T

    func body(content: Content) -> some View {
        content
            .environmentObject(service)
            .overlay(Proxy(tokens: $tokens).opacity(0))
            //new token
            .onReceive(service.tokens) {
                if let token = $0 as? T.Element {
                    let nonUnique = tokens.contains { $0.id == token.id }
                    guard !nonUnique else { return }
                    text = ""
                    tokens.append(token)
                }
            }
            //new text
            .onReceive(service.text) {
                text = $0
            }
    }
}

@available(iOS, deprecated: 16.0)
class CompletionService: ObservableObject {
    fileprivate let tokens: PassthroughSubject<AnyHashable, Never> = PassthroughSubject()
    fileprivate let text: PassthroughSubject<String, Never> = PassthroughSubject()
    
    func callAsFunction(_ token: AnyHashable) {
        if let string = token as? String {
            text.send(string)
        } else {
            tokens.send(token)
        }
    }
}

extension SearchableTokens {
    struct Proxy: UIViewControllerRepresentable {
        @Binding var tokens: T
        
        func makeUIViewController(context: Context) -> Holder {
            .init(self)
        }
        
        func updateUIViewController(_ holder: Holder, context: Context) {
            holder.render(self)
        }
    }
}

extension SearchableTokens { class Holder: UIViewController {
    var base: Proxy
    private weak var controller: UISearchController?
    private var cancelables = Set<AnyCancellable>()

    init(_ base: Proxy) {
        self.base = base
        super.init(nibName: nil, bundle: nil)
        self.render(base)
        
        NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)
            .sink(receiveValue: updateSearchResults)
            .store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
            .sink(receiveValue: updateSearchResults)
            .store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)
            .sink(receiveValue: updateSearchResults)
            .store(in: &cancelables)
        
        NotificationCenter.default.publisher(for: UITextField.keyboardDidHideNotification)
            .sink(receiveValue: updateSearchResults)
            .store(in: &cancelables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        guard controller != parent?.navigationItem.searchController else { return }
        controller = parent?.navigationItem.searchController
        
        controller?.searchBar.publisher(for: \.frame)
            .sink { _ in self.updateSearchResults() }
            .store(in: &cancelables)
        
        render(base)
    }
    
    //From SwiftUI
    func render(_ base: Proxy) {
        self.base = base
        controller?.searchBar.searchTextField.tokens = base.tokens.map {
            let token = UISearchToken(icon: nil, text: "\($0.id)")
            token.representedObject = $0
            return token
        }
    }
    
    //From UIKit
    func updateSearchResults(_ notification: Notification? = nil) {
        guard notification == nil || notification?.object is UISearchTextField else { return }
        
        //update tokens
        var tokens = T()
        controller?.searchBar.searchTextField.tokens.forEach {
            if let token = $0.representedObject as? T.Element {
                tokens.append(token)
            }
        }
        
        let newIds = Set(tokens.map { $0.id })
        let oldIds = Set(base.tokens.map { $0.id })
        if newIds != oldIds {
            base.tokens = tokens
        }
    }
}}
