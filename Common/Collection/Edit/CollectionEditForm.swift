import SwiftUI
import UI
import API

struct CollectionFields: View {
    @EnvironmentObject private var collections: CollectionsStore
    @Binding var collection: UserCollection
    
    var body: some View {
        IconPicker(selection: $collection.cover)

        Section {
            TextField("Title", text: $collection.title)
                .fontWeight(.semibold)
            
            TextField("Description", text: $collection.description, axis: .vertical)
                .lineLimit(2...)
        }
        
        Section("Parent") {
            CollectionPicker(
                id: $collection.parent,
                matching: .nestable
            ) {
                Text("None").foregroundStyle(.secondary)
            }
        }
    }
}
