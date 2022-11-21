import SwiftUI
import UI
import API

struct CollectionFields: View {
    @EnvironmentObject private var collections: CollectionsStore
    @Binding var collection: UserCollection
    
    var body: some View {
        IconPicker(selection: $collection.cover)

        Section {
            TextField("Title", text: $collection.title)
                .fontWeight(.semibold)
            
            TextField("Description", text: $collection.description, axis: .vertical)
                .lineLimit(2...)
        }
        
        Section {
            NavigationLink {
                
            } label: {
                LabeledContent("Location") {
                    CollectionLocation(collection: collection)
                        .lineLimit(1)
                        .truncationMode(.head)
                }
            }
        }
    }
}
