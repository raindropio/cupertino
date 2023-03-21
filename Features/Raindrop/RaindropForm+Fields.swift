import SwiftUI
import API
import UI

extension RaindropForm {
    struct Fields {
        @State private var cover = false
        
        @Binding var raindrop: Raindrop
        @FocusState var focus: FocusField?
    }
}

extension RaindropForm.Fields: View {
    var body: some View {
        Section {
            HStack(spacing: 8) {
                TextField(text: $raindrop.title, prompt: .init("Title"), axis: .vertical) {}
                    .labelsHidden()
                    .preventLineBreaks(text: $raindrop.title)
                    .focused($focus, equals: .title)
                    .fontWeight(.semibold)
                    .lineLimit(5)
                    .onSubmit {
                        focus = nil
                    }
                
                Button { cover.toggle() } label: {
                    Thumbnail(
                        (raindrop.isNew ? raindrop.cover : Rest.renderImage(raindrop.cover, options: .optimalSize)) ?? Rest.renderImage(raindrop.link, options: .optimalSize),
                        width: 56,
                        height: 48
                    )
                    .cornerRadius(3)
                }
                    .buttonStyle(.borderless)
                    .navigationDestination(isPresented: $cover) {
                        RaindropCoverGrid(raindrop: $raindrop)
                    }
            }
            
            TextField(text: $raindrop.excerpt, prompt: .init("Description"), axis: .vertical) {}
                .labelsHidden()
                .focused($focus, equals: .excerpt)
                .lineLimit(5)
        }
            .contentTransition(.opacity)
        
        Section {
            NavigationLink {
                RaindropCollection($raindrop)
            } label: {
                CollectionLabel(raindrop.collection, withLocation: true)
                    .badge(0)
                    .symbolVariant(.fill)
                    .fixedSize()
            }
                .id(raindrop.collection)
        } footer: {
            RaindropSuggestedCollections($raindrop)
        }
            .listItemTint(.monochrome)
        
        Section {
            //tags
            NavigationLink {
                RaindropTags($raindrop)
            } label: {
                Label {
                    TagsField($raindrop.tags)
                        .focused($focus, equals: .tags)
                } icon: {
                    Image(systemName: "number")
                }
            }

            //highlights
            NavigationLink {
                RaindropHighlights($raindrop)
            } label: {
                Label("Highlights", systemImage: Filter.Kind.highlights.systemImage)
                    .badge(NumberInCircle(raindrop.highlights.count).foregroundColor(Filter.Kind.highlights.color))
            }
            
            //url
            if raindrop.file == nil {
                Label {
                    URLField("", value: $raindrop.link, prompt: Text("URL"))
                        .labelsHidden()
                        .focused($focus, equals: .link)
                } icon: {
                    Image(systemName: "lock.fill")
                }
            }
        }
            .listItemTint(.monochrome)
    }
}

extension RaindropForm.Fields {
    enum FocusField {
        case title
        case excerpt
        case collection
        case tags
        case link
    }
}
