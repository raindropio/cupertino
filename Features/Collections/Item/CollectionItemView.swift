import SwiftUI
import API

struct CollectionItemView: View {
    var collection: Collection
    
    var body: some View {
        Label(collection.title, systemImage: "folder")
    }
}
