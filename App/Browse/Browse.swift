import SwiftUI
import API

struct Browse: View {
    var collection: Collection = .Preview.system.first!
    @State var search: SearchQuery = SearchQuery()

    @EnvironmentObject private var router: Router
    
    var body: some View {
        WithSearch(search: $search, in: collection) { collection in
            Raindrops(search: $search) {}
                .contextAction {
                    router.path.append(.preview($0))
                }
                .navigationTitle(
                    !search.isEmpty ?
                        (collection.id != 0 ? "\(collection.title) / " : "") + search.title :
                        collection.title
                )
                .toolbarRole(.editor)
        }
    }
}
