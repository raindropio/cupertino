import SwiftUI
import API
import UI

struct EditCollectionScreen: View {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var dispatch: Dispatcher

    @Environment(\.dismiss) private var dismiss
    @State var collection: UserCollection
    
    @State private var askDelete = false

    var body: some View {
        Form {
            CollectionEditForm(collection: $collection)
            
            if collection.access.level >= .member {
                Button(role: .destructive) {
                    askDelete = true
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                }
                    .clearSection()
                    .confirmationDialog("Are you sure?", isPresented: $askDelete) {
                        Button(role: .destructive) {
                            Task {
                                do {
                                    try await dispatch(CollectionsAction.delete(collection.id))
                                    dismiss()
                                } catch {}
                            }
                        } label: {
                            Text("Delete collection")
                        }
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
