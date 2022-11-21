import SwiftUI
import API
import UI

struct RaindropFields: View {
    @EnvironmentObject private var f: FiltersStore
    
    @Binding var raindrop: Raindrop
    @FocusState var focus: FocusField?
    
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
                TextField("URL", value: $raindrop.link, format: .url)
                    .focused($focus, equals: .link)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .textInputAutocapitalization(.never)
                    .truncationMode(.head)
                    .disableAutocorrection(true)
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

extension RaindropFields {
    enum FocusField {
        case title
        case excerpt
        case collection
        case tags
        case link
    }
}
