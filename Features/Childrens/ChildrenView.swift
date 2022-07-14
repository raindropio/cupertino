import SwiftUI
import API

struct ChildrenView<Tag: Hashable>: View {
    var parent: Collection
    var tag: (_ collection: Collection) -> Tag
    
    private let rows = [GridItem( .flexible(minimum: 100, maximum: 200) )]
    
    var body: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 16) {
                    ForEach(Collection.Preview.items) { collection in
                        NavigationLink(value: tag(collection)) {
                            CollectionRow(collection: collection)
                        }
                    }
                }
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .tint(.secondary)
        .accentColor(.black)
        .labelStyle(ChildrenLabelStyle())
        .listRowBackground(Color.clear)
        //.listRowInsets(EdgeInsets())
    }
}
