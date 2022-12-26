import SwiftUI
import API

public struct UserCollectionMenu: View {
    @EnvironmentObject private var event: CollectionEvent
    @EnvironmentObject private var dispatch: Dispatcher

    var collection: UserCollection
    
    public init(_ collection: UserCollection) {
        self.collection = collection
    }
    
    public var body: some View {
        Section {
            Button {
                event.create(.parent(collection.id))
            } label: {
                Label("Create collection", systemImage: "plus.rectangle.on.folder")
            }
        }
                
        Section {
            Button {
                event.edit(collection)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button {
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive) {
                event.delete(collection.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
