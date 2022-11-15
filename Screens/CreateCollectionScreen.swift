import SwiftUI
import API
import UI

struct CreateCollectionScreen: View {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @State var collection = UserCollection.new()

    var body: some View {
        Form {
            CollectionEditForm(collection: $collection)
        }
            .navigationTitle("New collection")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            do {
                                try await dispatch(CollectionsAction.create(collection))
                                dismiss()
                            } catch {}
                        }
                    }
                        .disabled(!collection.isValid)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
    }
}
