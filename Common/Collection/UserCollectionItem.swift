import SwiftUI
import API
import UI
import Backport

struct UserCollectionItem: View {
    @EnvironmentObject private var event: CollectionEvent
    var collection: UserCollection
    var withLocation = false
    
    init(_ collection: UserCollection) {
        self.collection = collection
    }
    
    init(_ collection: UserCollection, withLocation: Bool = false) {
        self.collection = collection
        self.withLocation = withLocation
    }
    
    var body: some View {
        UserCollectionLabel(collection, withLocation: withLocation)
            .dropConsumer(to: collection)
            .swipeActions(edge: .trailing) {
                Button {
                    event.edit(collection)
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                    .tint(.accentColor)
            }
            .swipeActions(edge: .leading) {
                Button {
                    event.create(.parent(collection.id))
                } label: {
                    Label("Create collection", systemImage: "plus")
                }
                    .tint(.indigo)
            }
    }
}
