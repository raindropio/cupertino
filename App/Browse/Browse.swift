import SwiftUI
import API

struct Browse: View {
    var collection: Collection = .Preview.system.first!
    @State var search: SearchQuery = SearchQuery()

    @EnvironmentObject private var router: Router
    @State private var test = CGFloat(0)
    
    var body: some View {
        WithSearch(search: $search, in: collection) { collection in
            Raindrops(search: $search) {
                Button("Test \(test)") { test += 1 }
                    .frame(height: 30 + test)
            }
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
