import SwiftUI
import API

struct Search: View {
    @State private var search = SearchQuery()
    @EnvironmentObject private var router: Router

    var body: some View {
        WithSearch(
            search: $search,
            placement: placement
        ) { _ in
            if search.isEmpty {
                
            } else {
                Raindrops(search: $search) {}
                    .contextAction {
                        router.path.append(.preview($0))
                    }
            }
        }
            .navigationTitle("Search")
    }
}

#if os(iOS)
private let placement = SearchFieldPlacement.navigationBarDrawer(displayMode: .always)
#else
private let placement = SearchFieldPlacement.sidebar
#endif
