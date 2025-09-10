import SwiftUI
import API

struct CollectionLocation: View {
    @EnvironmentObject private var collections: CollectionsStore
    var collection: UserCollection

    var body: some View {
        Memorized(
            collection: collection,
            location: collections.state.location(of: collection)
        )
    }
}

extension CollectionLocation {
    fileprivate struct Memorized: View {
        var collection: UserCollection
        var location: [UserCollection]
        
        var body: some View {
            Text(
                location
                    .map { $0.title }
                    .joined(separator: " / ")
            ) + Text(!location.isEmpty ? " / " : "") + Text(collection.title+" ")
        }
    }
}
