import SwiftUI
import API

struct SystemCollectionItem: View {
    @EnvironmentObject private var collections: CollectionsStore
    
    var id: SystemCollection.ID
    
    var body: some View {
        if let collection = collections.state.system[id] {
            Label {
                Text(collection.title)
                    .lineLimit(1)
            } icon: {
                CollectionIcon(collection)
            }
                .badge(collection.count)
        }
    }
}
