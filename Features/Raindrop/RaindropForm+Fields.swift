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
        HStack(alignment: .top, spacing: 16) {
            Button { cover.toggle() } label: {
                Thumbnail(
                    (raindrop.isNew ? raindrop.cover : Rest.renderImage(raindrop.cover, options: .optimalSize)) ?? Rest.renderImage(raindrop.link, options: .optimalSize),
                    width: 63,
                    height: 54
                )
                    .cornerRadius(6)
            }
                .buttonStyle(.borderless)
                .navigationDestination(isPresented: $cover) {
                    RaindropCoverGrid(raindrop: $raindrop)
                }
            
            VStack(spacing: 4) {
                //title
                TextField(text: $raindrop.title, prompt: .init("Title"), axis: .vertical) {}
                    .preventLineBreaks(text: $raindrop.title)
                    .focused($focus, equals: .title)
                    .fontWeight(.semibold)
                    .lineLimit(5)
                
                //excerpt
                if !raindrop.excerpt.isEmpty || focus == .title || focus == .excerpt {
                    TextField(text: $raindrop.excerpt, prompt: .init("Add description"), axis: .vertical) {}
                        .preventLineBreaks(text: $raindrop.excerpt)
                        .focused($focus, equals: .excerpt)
                        .lineLimit(focus == .excerpt ? nil : 1)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
                .labelsHidden()
                .frame(minHeight: 54)
                .onSubmit {
                    focus = nil
                }
        }
            .contentTransition(.opacity)
            .clearSection()
        
        //note
        Section {
            TextField(text: $raindrop.note, prompt: .init("Note"), axis: .vertical) {}
                .labelsHidden()
                .focused($focus, equals: .note)
                .lineLimit(3...)
        }
            .contentTransition(.opacity)
        
        //collection
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
            
            //reminder
            ProGroup {
                DatePresetField(
                    selection: .init { raindrop.reminder?.date } set: { if let date = $0 { raindrop.reminder = .init(date) } else { raindrop.reminder = nil } },
                    in: .now...
                ) {
                    Label(raindrop.reminder == nil ? "Add reminder" : "Reminder", systemImage: Filter.Kind.reminder.systemImage)
                }
            } free: {
                Label("Reminder", systemImage: Filter.Kind.reminder.systemImage)
                    .badge("Pro only")
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
                        .allowsTightening(true)
                        .minimumScaleFactor(0.8)
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
        case note
        case collection
        case tags
        case link
    }
}
