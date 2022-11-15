import SwiftUI
import UI
import API

struct CollectionEditForm: View {
    @EnvironmentObject private var collections: CollectionsStore
    @Binding var collection: UserCollection
    
    var body: some View {
        NavigationLink {
            IconPicker(selection: $collection.cover)
        } label: {
            Thumbnail(collection.cover, width: 64, height: 64)
                .frame(maxWidth: .infinity)
        }
            .clearSection()

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
