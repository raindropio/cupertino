import SwiftUI
import API

public struct UserCollectionLabel: View {
    var collection: UserCollection
    var withLocation = false
    
    public init(_ collection: UserCollection, withLocation: Bool = false) {
        self.collection = collection
        self.withLocation = withLocation
    }
    
    public var body: some View {
        Label {
            HStack(spacing: 0) {
                if withLocation {
                    CollectionLocation(collection: collection)
                        .lineLimit(1)
                        .truncationMode(.head)
                        .foregroundStyle(.secondary)
                }
                
                Text(collection.title+" ")
                    .lineLimit(1)
                    .layoutPriority(1)
            }
        } icon: {
            CollectionIcon(collection)
        }
            .badge(collection.count)
            .listItemTint(.monochrome)
    }
}
