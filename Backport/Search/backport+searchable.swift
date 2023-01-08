import SwiftUI
import Combine

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func searchable<C: RandomAccessCollection & RangeReplaceableCollection, T: View>(
        text: Binding<String>,
        tokens: Binding<C>,
        placement: SearchFieldPlacement = .automatic,
        prompt: Text? = nil,
        token: @escaping (C.Element) -> T
    ) -> some View where C.Element : Identifiable {
        if #available(iOS 16, *) {
            content
                .searchable(text: text, tokens: tokens, placement: placement, prompt: prompt, token: token)
        } else {
            content
                .modifier(ClearOnCancel(text: text))
                .searchable(
                    text: text,
                    placement: placement.isToolbar ? .navigationBarDrawer : placement, //on ipad toolbar placement buggy
                    prompt: prompt
                )
                .modifier(SearchableTokens(text: text, tokens: tokens))
        }
    }
}

fileprivate struct SearchableTokens<T: RandomAccessCollection & RangeReplaceableCollection>: ViewModifier where T.Element: Identifiable {
    @StateObject private var service = SearchCompletionToken()
    @Binding var text: String
    @Binding var tokens: T
    
    func convert(_ tokens: T) {
        if !tokens.isEmpty {
            text += ((text.hasSuffix(" ") || text.isEmpty) ? "" : " ") + tokens.map { "\($0)" }.joined(separator: " ") + " "
            self.tokens = .init()
        }
    }

    func body(content: Content) -> some View {
        content
            .environmentObject(service)
            //new token
            .onReceive(service.tokens) {
                if let token = $0 as? T.Element {
                    let nonUnique = tokens.contains { $0.id == token.id }
                    guard !nonUnique else { return }
                    convert(.init([token]))
                }
            }
            //convert tokens to text
            .task(id: tokens.count) {
                convert(tokens)
            }
    }
}

@available(iOS, deprecated: 16.0)
class SearchCompletionToken: ObservableObject {
    fileprivate let tokens: PassthroughSubject<AnyHashable, Never> = PassthroughSubject()
    
    func callAsFunction(_ token: AnyHashable) {
        tokens.send(token)
    }
}

fileprivate extension SearchFieldPlacement {
    var isToolbar: Bool {
        let str = "\(self)"
        return str.contains("automatic") || str.contains("toolbar")
    }
}

fileprivate struct ClearOnCancel: ViewModifier {
    @Environment(\.isSearching) private var isSearching
    @Binding var text: String

    func body(content: Content) -> some View {
        content.onChange(of: isSearching) {
            if !$0 {
                text = ""
            }
        }
    }
}
