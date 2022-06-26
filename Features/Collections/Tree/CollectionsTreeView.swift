import SwiftUI
import API

struct CollectionsTreeView<Tag: Hashable>: View {
    var tag: (_ collection: Collection) -> Tag
    
    var body: some View {
        Section("My collections") {
            ForEach(Collection.Preview.items) { collection in
                CollectionItemView(collection: collection)
                    .tag(tag(collection))
            }
        }
    }
}
