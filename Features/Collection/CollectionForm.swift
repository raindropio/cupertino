import SwiftUI
import API
import UI
import Backport

public struct CollectionForm {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    
    @Binding var collection: UserCollection
    @FocusState var focus: FocusField?

    public init(_ collection: Binding<UserCollection>) {
        self._collection = collection
    }
}

extension CollectionForm {
    private func commit() async throws {
        guard collection.isValid else { return }
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
            Fields(collection: $collection, focus: $focus)
            
            if collection.isNew {
                #if canImport(UIKit)
                SubmitButton("Create")
                    .disabled(!collection.isValid)
                #endif
            } else if collection.access.level >= .member {
                ActionButton(message: "This action will delete collection and all nested collections.\nItems will be moved to Trash.", role: .destructive, action: delete) {
                    Text("Delete").frame(maxWidth: .infinity)
                }
                    .buttonStyle(.borderless)
                    .tint(.red)
                    .listRowBackground(Color.red.opacity(0.1))
            }
        }
            .formStyle(.modern)
            .backport.defaultFocus($focus, .title)
            .submitLabel(.done)
            .navigationTitle(collection.isNew ? "New collection" : "Edit collection")
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                if collection.isNew {
                    #if canImport(AppKit)
                    ToolbarItem(placement: .confirmationAction) {
                        SubmitButton("Create")
                            .disabled(!collection.isValid)
                    }
                    #endif
                    
                    ToolbarItem {
                        SafariLink(destination: URL(string: "https://help.raindrop.io/collections")!) {
                            Label("Help", systemImage: "questionmark.circle")
                        }
                    }
                }
            }
            .onSubmit(commit)
    }
}

extension CollectionForm {
    enum FocusField {
        case title
    }
}
