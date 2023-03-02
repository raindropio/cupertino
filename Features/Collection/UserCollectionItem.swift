import SwiftUI
import API
import UI

public struct UserCollectionItem: View {
    @EnvironmentObject private var sheet: CollectionSheet
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
                    sheet.edit(collection)
                } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
                
                Button {
                    sheet.delete([collection.id])
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                    .tint(.red)
                
                Button {
                    sheet.share(collection)
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                    .tint(.blue)
            }
            .swipeActions(edge: .leading) {
                Button {
                    sheet.create(collection.id)
                } label: {
                    Label("Create collection", systemImage: "plus")
                }
                    .tint(.indigo)
            }
    }
}
