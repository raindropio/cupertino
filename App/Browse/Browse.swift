import SwiftUI
import API

struct Browse: View {
    var collection: Collection
    @State var search = SearchQuery()
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        WithSearch(search: $search, in: collection) { collection in
            RaindropsView(search: $search) {
                if !search.isEmpty {
                    Text("Search \(search.text) in \(collection.title)")
                }
            }
                .contextAction(forSelectionType: Raindrop.self) {
                    if $0.count == 1, let raindrop = $0.first {
                        router.path.append(.preview(raindrop))
                    }
                }
                .navigationTitle(collection.title)
        }
    }
}
