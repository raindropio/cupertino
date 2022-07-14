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
                        .frame(width: 32, height: 24)
                }
                
                #if os(iOS)
                ZStack{}.frame(width: 10)
                #endif
            }
                #if os(macOS)
                .buttonStyle(.borderless)
                .tint(.secondary)
                #endif
                .imageScale(.large)
        }
            #if os(macOS)
            .collapsible(false)
            #endif
    }
}
