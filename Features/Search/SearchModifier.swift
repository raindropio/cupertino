import SwiftUI
import API
import Combine

struct SearchModifier: ViewModifier {
    @Binding var collection: Collection
    @Binding var search: SearchQuery
    var placement: SearchFieldPlacement = .automatic
    
    @State private var isSearching = false
    @State private var scope: SearchScope = .everywhere
    @State private var origin: Collection? = nil
    @State private var hideSuggestions = false
    
    @Sendable
    func scopeApply() async {
        if isSearching {
            if !search.isEmpty {
                switch scope {
                case .everywhere:
                    if collection.id != 0 {
                        origin = collection
                        collection = .Preview.system.first!
                    }
                    
                case .incollection:
                    if let o = origin {
                        collection = o
                        origin = nil
                    }
                }
            }
        } else if let o = origin {
            collection = o
            origin = nil
        }
    }
        
    func body(content: Content) -> some View {
        content
            .modifier(Env(isSearching: $isSearching))
            //MARK: - Field
            .searchable(
                text: $search.text,
                tokens: $search.tokens,
                placement: placement
            ) { token in
                Label(token.title, systemImage: token.systemImage)
            }
            //MARK: - Scope
            .searchScopes($scope) {
                if collection.id != 0 || origin != nil {
                    Text("Everywhere").tag(SearchScope.everywhere)
                    Text((origin ?? collection).title).tag(SearchScope.incollection)
                }
            }
            .task(
                id: (isSearching ? 1 : 0)+(search.isEmpty ? 1 : 0)+(scope == .everywhere ? 1 : 0),
                scopeApply
            )
            //MARK: - Suggestions
            .searchSuggestions {
                SearchSuggestions(
                    collection: scope == .everywhere ? Collection.Preview.system.first! : (origin ?? collection),
                    search: search,
                    hide: $hideSuggestions
                )
            }
            .onChange(of: search.text) { _ in
                hideSuggestions = false
            }
    }
}

extension SearchModifier {
    struct Env: ViewModifier {
        @Binding var isSearching: Bool
        @Environment(\.isSearching) private var iss
        
        func body(content: Content) -> some View {
            content
                .onAppear { isSearching = iss }
                .onChange(of: iss) { isSearching = $0 }
        }
    }
}
