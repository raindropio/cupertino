import SwiftUI
import API

struct UserCollectionMenu: View {
    @EnvironmentObject private var action: CollectionActionsStore

    var collection: UserCollection
    
    var body: some View {
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

            Button(role: .destructive) {
                action(.delete(collection))
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
