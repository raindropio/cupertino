import SwiftUI
import UI
import API
import Backport

extension CollectionStack {
    struct Fields {
        @Binding var collection: UserCollection
        var focus: FocusState<FocusField?>.Binding
    }
}

extension CollectionStack.Fields: View {
    var body: some View {
        IconPicker(selection: $collection.cover)

        Section {
            TextField("Title", text: $collection.title)
                .focused(focus, equals: .title)
                .font(.headline)
            
            Backport.TextField("Description", text: $collection.description, axis: .vertical)
                .preventLineBreaks(text: $collection.description)
                .focused(focus, equals: .description)
                .backport.lineLimit(2...)
        }
        
        Section("Parent") {
            CollectionPicker(
                id: $collection.parent,
                matching: .nestable
            ) {
                Text("None").foregroundStyle(.secondary)
            }
        }
    }
}

