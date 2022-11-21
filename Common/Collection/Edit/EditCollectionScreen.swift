import SwiftUI
import API
import UI

struct EditCollectionScreen: View {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var dispatch: Dispatcher

    @Environment(\.dismiss) private var dismiss
    @State var collection: UserCollection
    
    var body: some View {
        Form {
            CollectionFields(collection: $collection)
            
            if collection.access.level >= .member {
                ActionButton(role: .destructive) {
                    try await dispatch(CollectionsAction.delete(collection.id))
                    dismiss()
                } label: {
                    Text("Delete collection").frame(maxWidth: .infinity)
                }
            }
        }
            .navigationTitle("Edit collection")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onDisappear {
                dispatch.sync(CollectionsAction.update(collection))
            }
    }
}
