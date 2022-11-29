import SwiftUI
import API
import UI

extension RaindropStack {
    struct Fields {
        @Binding var raindrop: Raindrop
        @FocusState var focus: FocusField?
    }
}

extension RaindropStack.Fields: View {
    var body: some View {
        CoverPicker(selection: $raindrop.cover, media: raindrop.media)
        
        Section {
            TextField("Title", text: $raindrop.title, axis: .vertical)
                .preventLineBreaks(text: $raindrop.title)
                .focused($focus, equals: .title)
                .fontWeight(.semibold)
                .lineLimit(5)
                .onSubmit {
                    focus = nil
                }

            TextField("Description", text: $raindrop.excerpt, axis: .vertical)
                .focused($focus, equals: .excerpt)
                .lineLimit(2...5)
        }

        Section {
            CollectionPicker(
                id: $raindrop.collection,
                matching: .insertable,
                prompt: "Select collection"
            )

            Label {
                TagsPicker($raindrop.tags)
                    .tokenFieldStyle(.menu)
            } icon: {
                Image(systemName: "number")
            }

            Label {
                URLField("URL", value: $raindrop.link)
                    .focused($focus, equals: .link)
            } icon: {
                Image(systemName: "globe")
            }

            Toggle(isOn: $raindrop.important) {
                Label("Favorite", systemImage: "heart")
                    .symbolVariant(raindrop.important ? .fill : .none)
            }
                .listItemTint(raindrop.important ? Filter.Kind.important.color : .secondary)
        }
            .listItemTint(.secondary)
    }
}

extension RaindropStack.Fields {
    enum FocusField {
        case title
        case excerpt
        case collection
        case tags
        case link
    }
}
