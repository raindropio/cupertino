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
        IconPicker(selection: $collection.cover)

        Section {
            TextField("Title", text: $collection.title)
                .autoFocus()
                .backport.fontWeight(.semibold)
            
            Backport.TextField("Description", text: $collection.description, axis: .vertical)
                .preventLineBreaks(text: $collection.description)
                .backport.lineLimit(2...)
        }
        
        Section("Parent") {
            CollectionsPicker($collection.parent)
        }
    }
}

