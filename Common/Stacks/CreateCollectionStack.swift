import SwiftUI
import API
import UI

public struct CreateCollectionStack {
    @EnvironmentObject private var collections: CollectionsStore
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    @State var collection: UserCollection
    
    public init(_ location: Location = .group()) {
        self._collection = State(
            initialValue: {
                switch location {
                case .parent(let parent):
                    return .new(parent: parent > 0 ? parent : nil)
                case .group(_):
                    return .new()
                }
            }()
        )
    }
}

extension CreateCollectionStack: View {
    public var body: some View {
        NavigationStack {
            CollectionForm(collection: $collection)
                .navigationTitle("New collection")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        ActionButton("Create") {
                            try await dispatch(CollectionsAction.create(collection))
                            dismiss()
                        }
                            .disabled(!collection.isValid)
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}
