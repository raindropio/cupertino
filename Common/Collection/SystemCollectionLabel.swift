import SwiftUI
import API

struct SystemCollectionLabel: View {
    var collection: SystemCollection
    
    init(_ collection: SystemCollection) {
        self.collection = collection
    }
    
    var body: some View {
        Label {
            Text(collection.title)
                .lineLimit(1)
        } icon: {
            CollectionIcon(collection)
        }
            .badge(collection.count)
            .listItemTint(collection.color)
    }
}
