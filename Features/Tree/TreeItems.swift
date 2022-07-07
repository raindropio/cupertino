import SwiftUI
import API

struct TreeItems<Tag: Hashable>: View {
    var tag: (_ collection: Collection) -> Tag
    
    var body: some View {
        Section {
            ForEach(Collection.Preview.items) { collection in
                CollectionRow(collection: collection)
                    .tag(tag(collection))
            }
                .onDelete { a in
                    print(a)
                }
        } header: {
            HStack {
                Text("My collections")
                
                Spacer()
                
                Button {
                    print("a")
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
                    .buttonStyle(.borderless)
                    .padding(.vertical, 6)
                
                ZStack{}.frame(width: 16)
            }
        }
    }
}
