import SwiftUI
import API

public struct UserCollectionMenu: View {
    @EnvironmentObject private var action: CollectionActionsStore
    @EnvironmentObject private var dispatch: Dispatcher

    var collection: UserCollection
    
    public init(_ collection: UserCollection) {
        self.collection = collection
    }
    
    public var body: some View {
        Section {
            Button {
                action(.create(.parent(collection.id)))
            } label: {
                Label("Create collection", systemImage: "plus.rectangle.on.folder")
            }
        }
                
        Section {
            Button {
                action(.edit(collection))
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button {
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Menu {
                Button(role: .destructive) {
                    dispatch.sync(CollectionsAction.delete(collection.id))
                } label: {
                    Label("Delete \(collection.title)", systemImage: "trash")
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .tint(.red)
            }
        }
    }
}
