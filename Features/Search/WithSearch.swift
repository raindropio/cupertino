import SwiftUI
import API
import Combine

struct WithSearch<Content: View>: View {
    @Binding var search: SearchQuery
    var `in`: Collection = .Preview.system.first!
    var placement: SearchFieldPlacement = .automatic
    var content: (_ searchIn: Collection) -> Content
    
    @State private var isSearching = false
    @State private var scope: SearchScope = .everywhere
    @State private var origin: Collection? = nil
    @State private var hideSuggestions = false
    
    var body: some View {
        let suggestionsFor = scope == .everywhere ? .Preview.system.first! : `in`
        let searchIn = isSearching && !search.isEmpty ? suggestionsFor : `in`
        
        content(searchIn)
            .modifier(WithSearchEnv(isSearching: $isSearching))
            .searchable(
                text: $search.text,
                tokens: $search.tokens,
                placement: placement
            ) {
                Label($0.title, systemImage: $0.systemImage)
            }
            .searchScopes($scope) {
                if `in`.id != 0 {
                    Text("Everywhere").tag(SearchScope.everywhere)
                    Text(`in`.title).tag(SearchScope.incollection)
                }
            }
            .searchSuggestions {
                SearchSuggestions(
                    collection: suggestionsFor,
                    search: search,
                    hide: $hideSuggestions
                )
            }
            .onChange(of: search.text) { _ in
                hideSuggestions = false
            }
    }
}

private struct WithSearchEnv: ViewModifier {
    @Binding var isSearching: Bool
    @Environment(\.isSearching) private var iss
    
    func body(content: Content) -> some View {
        content
            .onAppear { isSearching = iss }
            .onChange(of: iss) { isSearching = $0 }
    }
}
