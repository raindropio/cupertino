import SwiftUI
import API

struct CollectionLocation: View {
    @EnvironmentObject private var collections: CollectionsStore
    var collection: UserCollection

    var body: some View {
        Memorized(
            location: collections.state.location(of: collection)
        )
    }
}

extension CollectionLocation {
    fileprivate struct Memorized: View {
        var location: [UserCollection]
        
        var body: some View {
            if !location.isEmpty {
                Text(
                    location
                        .map { $0.title }
                        .joined(separator: " / ")
                ) + Text(" / ")
            }
        }
    }
}
