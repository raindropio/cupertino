import SwiftUI
import API

struct Search: View {
    @State private var search = SearchQuery()
    
    var body: some View {
        WithSearch(
            search: $search,
            placement: .navigationBarDrawer(displayMode: .always)
        ) { _ in
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
