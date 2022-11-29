import SwiftUI
import UI
import API

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
                .fontWeight(.semibold)
            
            TextField("Description", text: $collection.description, axis: .vertical)
                .preventLineBreaks(text: $collection.description)
                .focused(focus, equals: .description)
                .lineLimit(2...)
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

