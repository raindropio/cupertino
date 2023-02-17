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
            HStack(spacing: 16) {
                Button { cover.toggle() } label: {
                    Thumbnail(
                        (raindrop.isNew ? raindrop.cover : Rest.renderImage(raindrop.cover, options: .maxDeviceSize)) ?? Rest.renderImage(raindrop.link, options: .maxDeviceSize),
                        width: 56,
                        height: 48
                    )
                    .cornerRadius(3)
                }
                    .buttonStyle(.borderless)
                    .navigationDestination(isPresented: $cover) {
                        CoverPicker(raindrop: $raindrop)
                    }
                    .padding(.top, 10)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                TextField("Title", text: $raindrop.title, axis: .vertical)
                    .preventLineBreaks(text: $raindrop.title)
                    .focused($focus, equals: .title)
                    .fontWeight(.semibold)
                    .lineLimit(5)
                    .onSubmit {
                        focus = nil
                    }
            }
            
            TextField("Description", text: $raindrop.excerpt, axis: .vertical)
                .focused($focus, equals: .excerpt)
                .lineLimit(5)
        }
        
        Section {
            NavigationLink {
                RaindropCollection($raindrop)
            } label: {
                CollectionLabel(raindrop.collection, withLocation: true)
                    .badge(0)
                    .symbolVariant(.fill)
            }
                .id(raindrop.collection)
        } header: {
            Text("Collection")
        } footer: {
            RaindropSuggestedCollections($raindrop)
        }
            .listItemTint(.monochrome)
        
        Section {
            //tags
            HStack {
                Label {
                    TagsField($raindrop.tags)
                        .focused($focus, equals: .tags)
                } icon: {
                    Image(systemName: "number")
                }
                
                NavigationLink {
                    RaindropTags($raindrop)
                } label: {}
                    .layoutPriority(-1)
            }
            
            Label {
                if raindrop.file == nil {
                    URLField("URL", value: $raindrop.link)
                        .focused($focus, equals: .link)
                }
            } icon: {
                Button { raindrop.important.toggle() } label: {
                    Image(systemName: "heart")
                        .symbolVariant(raindrop.important ? .fill : .none)
                        .imageScale(.medium)
                }
                    .buttonStyle(.borderless)
                    .tint(raindrop.important ? .accentColor : .secondary)
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
