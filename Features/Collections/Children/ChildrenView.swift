import SwiftUI
import API

struct ChildrenView: View {
    var collection: Collection
    
    private let rows = [GridItem( .flexible(minimum: 100, maximum: 200) )]
    
    var body: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 16) {
                    ForEach(Collection.Preview.items) { collection in
                        NavigationLink(value: collection) {
                            CollectionItemView(collection: collection)
                        }
                            .tag(collection)
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
