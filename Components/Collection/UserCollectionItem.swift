import SwiftUI
import API

struct UserCollectionItem: View {    
    var collection: UserCollection
    var withLocation = false
    
    var body: some View {
        Label {
            if withLocation {
                CollectionLocation(collection: collection)
                    .lineLimit(1)
                    .truncationMode(.head)
                    .foregroundStyle(.secondary)
            }
            
            Text(collection.title+" ")
                .lineLimit(1)
                .layoutPriority(1)
        } icon: {
            CollectionIcon(collection)
        }
            .badge(collection.count)
    }
}
