import SwiftUI
import API

struct SystemCollectionItem: View {
    var collection: SystemCollection
    
    init(_ collection: SystemCollection) {
        self.collection = collection
    }
    
    var body: some View {
        SystemCollectionLabel(collection)
            .dropConsumer(to: collection.id)
    }
}
