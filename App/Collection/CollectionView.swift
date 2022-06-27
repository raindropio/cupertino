import SwiftUI
import API

struct CollectionView: View {
    var collection: Collection
    @State private var selection = Set<Raindrop>()
    
    var body: some View {
        List(selection: $selection) {
            if !collection.isSystem {
                ChildrenView(collection: collection)
            }
            
            RaindropItems()
        }
            .listStyle(.inset)
            .navigationTitle(collection.title)
    }
}
