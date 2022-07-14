import SwiftUI
import API

struct CollectionRow: View {
    var collection: Collection
    
    var body: some View {
        Label(collection.title, systemImage: "folder")
    }
}
