import SwiftUI
import API

struct SearchCollections: View {
    @EnvironmentObject private var collections: CollectionsStore
    var search: String
    
    init(search: String) {
        self.search = search
    }
    
    init(find: FindBy) {
        if find.collectionId == 0 {
            self.search = find.text
        } else {
            self.search = ""
        }
    }
    
    var body: some View {
        Memorized(
            user: collections.state.find(search)
        )
    }
}

extension SearchCollections {
    fileprivate struct Memorized: View {
        var user: [UserCollection]
        
        var body: some View {
            if !user.isEmpty {
                Section("\(user.count) collections") {
                    ForEach(user) { item in
                        UserCollectionItem(collection: item, withLocation: true)
                            .id(item.id)
                    }
                }
            }
        }
    }
}
