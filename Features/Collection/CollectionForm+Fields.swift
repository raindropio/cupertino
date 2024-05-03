import SwiftUI
import UI
import API
import Backport

extension CollectionForm {
    struct Fields {
        @Binding var collection: UserCollection
        var focus: FocusState<FocusField?>.Binding
    }
}

extension CollectionForm.Fields: View {
    var body: some View {
        Section {
            HStack {
                TextField(text: $collection.title, prompt: .init("Title")) {}
                    .labelsHidden()
                    .fontWeight(.semibold)
                    .backport.focused(focus, equals: .title)
                
                Icon(collection: $collection)
            }
            
            TextField(text: $collection.description, prompt: .init("Description"), axis: .vertical) {}
                .labelsHidden()
                .lineLimit(2...)
        }
        
        Section {
            NavigationLink {
                CollectionParent($collection)
            } label: {
                LabeledContent("Parent") {
                    if let parent = collection.parent {
                        CollectionLabel(parent, withLocation: true)
                            .labelStyle(.titleAndIcon)
                            .controlSize(.small)
                    } else {
                        Text("None")
                    }
                }
            }
            
            if !collection.isNew {
                NavigationLink {
                    CollectionSharing($collection)
                } label: {
                    LabeledContent("Sharing") {
                        if collection.public {
                            Circle().fill(.tint).frame(width: 8, height: 8)
                            Text("Public")
                        } else {
                            (Text(Image(systemName: "lock.fill")) + Text(" Private"))
                                .foregroundStyle(.secondary)
                                .imageScale(.small)
                        }
                    }
                }
            }
        }
            .listItemTint(.monochrome)
    }
}

