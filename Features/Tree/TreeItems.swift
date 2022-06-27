import SwiftUI
import API

struct TreeItems<Tag: Hashable>: View {
    var tag: (_ collection: Collection) -> Tag
    
    var body: some View {
        Section("My collections") {
            ForEach(Collection.Preview.items) { collection in
                CollectionRow(collection: collection)
                    .tag(tag(collection))
            }
                .onDelete { a in
                    print(a)
                }
        }
    }
}
