import SwiftUI
import API

struct Search: View {
    private var collection: Collection = .Preview.system.first!
    @State private var search = SearchQuery()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Search")
            .modifier(SearchModifier(collection: collection, search: $search))
    }
}
