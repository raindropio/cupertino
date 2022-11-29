import SwiftUI
import API
import UI

public struct CollectionStack {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @State private var collection: UserCollection
    @FocusState var focus: FocusField?
    
    public init(_ collection: UserCollection) {
        self._collection = State(initialValue: collection)
    }
    
    public init(_ new: NewLocation = .group()) {
        self._collection = State(
            initialValue: {
                switch new {
                case .parent(let parent):
                    return .new(parent: parent > 0 ? parent : nil)
                case .group(_):
                    return .new()
                }
            }()
        )
    }
}

extension CollectionStack {
    private var isNew: Bool {
        collection.id == 0
    }
    
    private func commit() async throws {
        try await dispatch(isNew ? CollectionsAction.create(collection) : CollectionsAction.update(collection))
        dismiss()
    }
    
    private func delete() async throws {
        try await dispatch(CollectionsAction.delete(collection.id))
        dismiss()
    }
    
    private func saveOnClose() {
        guard !isNew else { return }
        Task { try? await commit() }
    }
}

extension CollectionStack: View {
    public var body: some View {
        NavigationStack {
            Form {
                Fields(collection: $collection, focus: $focus)
                
                if isNew {
                    SubmitButton("Create")
                } else if collection.access.level >= .member {
                    ActionButton(role: .destructive, action: delete) {
                        Text("Delete collection").frame(maxWidth: .infinity)
                    }
                }
            }
                .submitLabel(.done)
                .onSubmit(commit)
                .navigationTitle(isNew ? "New collection" : "Edit collection")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: isNew ? .cancellationAction : .confirmationAction) {
                        Button(isNew ? "Cancel" : "Done", action: dismiss.callAsFunction)
                    }
                }
        }
            //focus on title for new
            .onAppear {
                if isNew {
                    focus = .title
                }
            }
            //auto-save for existing collection
            .onDisappear(perform: saveOnClose)
    }
}
