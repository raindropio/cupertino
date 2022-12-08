import SwiftUI
import API
import UI

extension CollectionsList {
    struct Find: View {
        @EnvironmentObject private var collections: CollectionsStore
        var search: String
        
        var body: some View {
            Memorized(
                user: collections.state.find(search)
            )
        }
    }
}

extension CollectionsList.Find {
    fileprivate struct Memorized: View {
        var user: [UserCollection]
        
        var body: some View {
            if !user.isEmpty {
                Section("Found \(user.count) collections") {
                    ForEach(user) { item in
                        UserCollectionRow(item, withLocation: true)
                            .dropConsumer(to: item)
                            .backport.tag(item.id)
                    }
                }
            }
        }
    }
}
