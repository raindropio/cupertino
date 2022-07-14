import SwiftUI
import API

struct Browse: View {
    @State var collection: Collection
    @State var search = SearchQuery()
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        RaindropsView(search: $search) {
            if !search.isEmpty {
                Text("Search \(search.text) in \(collection.title)")
            }
        }
            .modifier(SearchModifier(collection: $collection, search: $search))
            .contextAction(forSelectionType: Raindrop.self) {
                if $0.count == 1, let raindrop = $0.first {
                    router.path.append(.preview(raindrop))
                }
            }
            .navigationTitle(collection.title)
    }
}
