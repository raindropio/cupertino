import SwiftUI
import UI
import API

struct CollectionForm<F: View> {
    @EnvironmentObject private var collections: CollectionsStore
    @Binding var collection: UserCollection
    var footer: (() -> F)?
    
    init(
        collection: Binding<UserCollection>,
        @ViewBuilder footer: @escaping () -> F
    ) {
        self._collection = collection
        self.footer = footer
    }
}

extension CollectionForm: View {
    var body: some View {
        Form {
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
            
            footer?()
        }
    }
}

extension CollectionForm where F == EmptyView {
    init(collection: Binding<UserCollection>) {
        self._collection = collection
    }
}
