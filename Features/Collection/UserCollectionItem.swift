import SwiftUI
import API
import UI

public struct UserCollectionItem: View {
    @EnvironmentObject private var event: CollectionsEvent
    var collection: UserCollection
    var withLocation = false
    
    public init(_ collection: UserCollection) {
        self.collection = collection
    }
    
    public init(_ collection: UserCollection, withLocation: Bool = false) {
        self.collection = collection
        self.withLocation = withLocation
    }
    
    public var body: some View {
        CollectionLabel(collection, withLocation: withLocation)
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
