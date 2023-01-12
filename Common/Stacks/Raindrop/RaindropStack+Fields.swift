import SwiftUI
import API
import UI
import Backport

extension RaindropStack {
    struct Fields {
        @Binding var raindrop: Raindrop
        @FocusState var focus: FocusField?
    }
}

extension RaindropStack.Fields: View {
    var body: some View {
        CoverPicker(
            url: raindrop.link,
            selection: $raindrop.cover,
            media: $raindrop.media
        )
        
        Section {
            Backport.TextField("Title", text: $raindrop.title, axis: .vertical)
                .preventLineBreaks(text: $raindrop.title)
                .focused($focus, equals: .title)
                .backport.fontWeight(.semibold)
                .lineLimit(5)
                .onSubmit {
                    focus = nil
                }

            Backport.TextField("Description", text: $raindrop.excerpt, axis: .vertical)
                .focused($focus, equals: .excerpt)
                .backport.lineLimit(2...5)
        }

        Section {
            CollectionPickerLink($raindrop.collection, system: [-1, -99])

            HStack {
                Label {
                    TagsField($raindrop.tags)
                        .focused($focus, equals: .tags)
                } icon: {
                    Image(systemName: "number")
                }
                
                NavigationLink {
                    TagsPicker($raindrop.tags)
                        .navigationTitle("\(raindrop.tags.count) tags")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {}
                    .layoutPriority(-1)
            }
            
            Label {
                URLField("URL", value: $raindrop.link)
                    .focused($focus, equals: .link)
            } icon: {
                Image(systemName: "globe")
            }
        }
            .listItemTint(.monochrome)
        
        Section {
            NavigationLink {
                HighlightsList(raindrop: $raindrop)
                    .navigationTitle(Filter.Kind.highlights.title)
            } label: {
                Label(Filter.Kind.highlights.title, systemImage: Filter.Kind.highlights.systemImage)
                    .badge(raindrop.highlights.count)
            }
            
            Toggle(isOn: $raindrop.important) {
                Label("Favorite", systemImage: "heart")
                    .symbolVariant(raindrop.important ? .fill : .none)
            }
                .listItemTint(raindrop.important ? Filter.Kind.important.color : .secondary)
        }
            .listItemTint(.monochrome)
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
