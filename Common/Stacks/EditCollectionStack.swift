import SwiftUI
import API
import UI

public struct EditCollectionStack {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    @State var collection: UserCollection
    
    public init(_ collection: UserCollection) {
        self._collection = State(initialValue: collection)
    }
}

extension EditCollectionStack: View {
    public var body: some View {
        NavigationStack {
            CollectionForm(collection: $collection) {
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
                        Button("Done") { dismiss() }
                    }
                }
        }
            .onDisappear {
                dispatch.sync(CollectionsAction.update(collection))
            }
    }
}
