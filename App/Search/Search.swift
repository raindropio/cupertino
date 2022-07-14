import SwiftUI
import API

struct Search: View {
    @State private var collection: Collection = .Preview.system.first!
    @State private var search = SearchQuery()
    
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.secondary)
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
            .modifier(
                SearchModifier(
                    collection: $collection,
                    search: $search,
                    placement: .navigationBarDrawer(displayMode: .always)
                )
            )
    }
}
