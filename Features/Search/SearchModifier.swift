import SwiftUI
import API

struct SearchModifier: ViewModifier {
    @Binding var collection: Collection
    @Binding var query: String
    
    @Environment(\.isSearching) private var isSearching: Bool
    @State private var text: String = ""
    @State private var tokens: [SearchToken] = []
    @State private var scope: SearchScope = .everywhere
    @State private var origin: Collection?
    @State private var hideSuggestions = false
    
    func prepare(_ query: String) {
        if text != query {
            text = query
        }
    }
    
    func apply(_ text: String) {
        if text != query {
            query = text
        }
    }
    
    func body(content: Content) -> some View {
        content
            .modifier(SearchEffect(collection: $collection, origin: $origin, query: $query, scope: $scope))
            .onAppear { prepare(query) }
            .onChange(of: query) { prepare($0) }
            .onChange(of: text) { apply($0) }
            .searchable(text: $text, tokens: $tokens) { token in
                Text(token.label)
            }
            .searchScopes($scope) {
                if collection.id != 0 || origin != nil {
                    Text("Everywhere")
                        .tag(SearchScope.everywhere)
                    Text((origin ?? collection).title)
                        .tag(SearchScope.incollection)
                }
            }
            .onChange(of: text) { _ in hideSuggestions = false }
            .searchSuggestions {
                if !hideSuggestions {
                    if !text.isEmpty {
                        Button(text) {
                            hideSuggestions = true
                        }
                    }
                    
                    Text(SearchToken.matchOr.label)
                        .searchCompletion(
                            SearchToken.matchOr
                        )
                }
            }
    }
}

extension SearchModifier {
    struct SearchEffect: ViewModifier {
        @Binding var collection: Collection
        @Binding var origin: Collection?
        @Binding var query: String
        @Binding var scope: SearchScope
        
        @Environment(\.isSearching) var isSearching
        
        func apply(_ isSearching: Bool) {
            if isSearching {
                if !query.isEmpty {
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
                .onChange(of: isSearching) {
                    if $0, collection.id != 0, !query.isEmpty {
                        scope = .incollection
                    }
                    
                    apply($0)
                }
                .onChange(of: query) { _ in apply(isSearching) }
                .onChange(of: scope) { _ in apply(isSearching) }
        }
    }
}
