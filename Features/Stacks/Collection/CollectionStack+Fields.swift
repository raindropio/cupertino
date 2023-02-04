import SwiftUI
import UI
import API
import Backport

extension CollectionStack {
    struct Fields {
        @Binding var collection: UserCollection
    }
}

extension CollectionStack.Fields: View {
    var body: some View {
        Section {
            Label {
                TextField("Title", text: $collection.title)
                    .backport.fontWeight(.semibold)
                    .autoFocus()
            } icon: {
                IconPicker(collection: $collection)
            }
            
            Label {
                Backport.TextField("Description", text: $collection.description, axis: .vertical)
                    .preventLineBreaks(text: $collection.description)
                    .backport.lineLimit(2...)
            } icon: {
                Color.clear
            }
        }
        
        Section("Parent") {
            CollectionsPicker($collection.parent)
        }
    }
}

