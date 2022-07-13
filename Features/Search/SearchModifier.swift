import SwiftUI
import API
import Combine

struct SearchModifier: ViewModifier {
    @Binding var collection: Collection
    @Binding var query: String
    @StateObject private var service = SearchService()
    
    func body(content: Content) -> some View {
        content
            //MARK: - Two way binding
            .modifier(ReactToEnv(service: service))
            .task(id: collection.id) { service.collection = collection }
            .task(id: service.collection?.id) { if service.collection != nil { collection = service.collection } }
            .task(id: query) { service.setQuery(query) }
            .task(id: service.tokens) { query = service.getQuery() }
            .task(id: service.text) { query = service.getQuery() }
            //MARK: - UI
            //Tokens are very slow in ios 16 beta 3 :(
            .searchable(text: $service.text, tokens: $service.tokens) { token in
                Label(token.label, systemImage: token.systemImage)
            }
            //MARK: - Scope
            //Active state bug ios 16 beta 3 :(
            .searchScopes($service.scope) {
                if let secondScope = service.secondScope {
                    Text("Everywhere")
                        .tag(SearchScope.everywhere)
                    Text(secondScope.title)
                        .tag(SearchScope.incollection)
                }
            }
            //MARK: - Suggestions
            .searchSuggestions {
                if !service.hideSuggestions {
                    if !service.text.isEmpty {
                        Button {
                            service.hideSuggestions = true
                        } label: {
                            Label(service.text, systemImage: "magnifyingglass")
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
    struct ReactToEnv: ViewModifier {
        @ObservedObject var service: SearchService
        @Environment(\.isSearching) var isSearching
        
        func body(content: Content) -> some View {
            content
                .task(id: isSearching) { service.isSearching = isSearching }
        }
    }
}
