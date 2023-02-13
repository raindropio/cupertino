import SwiftUI
import API
import UI

public struct CollectionForm {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    @Binding var collection: UserCollection
    
    public init(_ collection: Binding<UserCollection>) {
        self._collection = collection
    }
}

extension CollectionForm {
    private func commit() async throws {
        try await dispatch(collection.isNew ? CollectionsAction.create(collection) : CollectionsAction.update(collection))
        dismiss()
    }
    
    private func delete() async throws {
        try await dispatch(CollectionsAction.delete(collection.id))
        dismiss()
    }
}

extension CollectionForm: View {
    public var body: some View {
        Form {
            Fields(collection: $collection)
            
            if collection.isNew {
                SubmitButton("Create")
            } else if collection.access.level >= .member {
                ActionButton(message: "This action will delete collection and all nested collections.\nBookmarks will be moved to Trash.", role: .destructive, action: delete) {
                    Text("Delete collection").frame(maxWidth: .infinity)
                }
            }
        }
            .submitLabel(.done)
            .onSubmit(commit)
            .navigationTitle(collection.isNew ? "New collection" : "Edit collection")
            .navigationBarTitleDisplayMode(.inline)
    }
}
