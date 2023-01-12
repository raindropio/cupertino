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
        Section {
            HStack(spacing: 16) {
                ZStack {
                    Thumbnail(
                        Rest.renderImage(raindrop.cover, options: .maxDeviceSize),
                        width: 56,
                        height: 48
                    )
                        .cornerRadius(3)
                    
                    NavigationLink {
                        CoverPicker(raindrop: $raindrop)
                    } label: {}
                        .opacity(0.00001)
                        .layoutPriority(-1)
                }
                    .padding(.top, 10)
                    .frame(maxHeight: .infinity, alignment: .top)
                
                Backport.TextField("Title", text: $raindrop.title, axis: .vertical)
                    .preventLineBreaks(text: $raindrop.title)
                    .focused($focus, equals: .title)
                    .backport.fontWeight(.semibold)
                    .lineLimit(5)
                    .onSubmit {
                        focus = nil
                    }
                    .frame(maxHeight: .infinity)
            }
            
            Backport.TextField("Description", text: $raindrop.excerpt, axis: .vertical)
                .focused($focus, equals: .excerpt)
                .lineLimit(5)
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
        }
            .listItemTint(.monochrome)
        
        if raindrop.file == nil {
            Section {
                URLField("URL", value: $raindrop.link)
                    .focused($focus, equals: .link)
                    .font(.subheadline)
                    .foregroundStyle(focus == .link ? .primary : .secondary)
            }
        }
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
