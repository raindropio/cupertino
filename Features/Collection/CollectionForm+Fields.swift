import SwiftUI
import UI
import API

extension CollectionForm {
    struct Fields {
        @Binding var collection: UserCollection
    }
}

extension CollectionForm.Fields: View {
    var body: some View {
        Section {
            Label {
                TextField("Title", text: $collection.title)
                    .fontWeight(.semibold)
                    .autoFocus()
            } icon: {
                IconPicker(collection: $collection)
            }
            
            Label {
                TextField("Description", text: $collection.description, axis: .vertical)
                    .preventLineBreaks(text: $collection.description)
                    .lineLimit(2...)
            } icon: {
                Color.clear
            }
        }
        
        Section("Parent") {            
            NavigationLink {
                CollectionParent($collection)
            } label: {
                if let parent = collection.parent {
                    CollectionLabel(parent, withLocation: true)
                        .badge(0)
                } else {
                    Text("None")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

