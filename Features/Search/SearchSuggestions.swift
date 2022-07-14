import SwiftUI
import API

struct SearchSuggestions: View {
    var collection: Collection
    var search: SearchQuery
    @Binding var hide: Bool
    
    var body: some View {
        if !hide {
            if !search.text.isEmpty {
                Button {
                    hide = true
                } label: {
                    Label(search.text, systemImage: "magnifyingglass")
                }
            }
        }
    }
}
