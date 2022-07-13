import SwiftUI
import API

struct Browse: View {
    @State var collection: Collection
    @State var query: String
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        RaindropsView(query: $query) {
            if !query.isEmpty {
                Text("Search \(query) in \(collection.title)")
            }
        }
            .modifier(SearchModifier(collection: $collection, query: $query))
            .contextAction(forSelectionType: Raindrop.self) {
                if $0.count == 1, let raindrop = $0.first {
                    router.path.append(.preview(raindrop))
                }
            }
            .navigationTitle(collection.title)
            .toolbarRole(.browser)
    }
}
