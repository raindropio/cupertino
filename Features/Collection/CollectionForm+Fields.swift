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
                TextField("Title", text: $collection.title)
                    .fontWeight(.semibold)
                    .backport.focused(focus, equals: .title)
                
                Icon(collection: $collection)
            }
            
            TextField("Description", text: $collection.description, axis: .vertical)
                .preventLineBreaks(text: $collection.description)
                .lineLimit(2...)
        }
        
        Section {
            LabeledContent("Parent") {
                NavigationLink {
                    CollectionParent($collection)
                } label: {
                    if let parent = collection.parent {
                        CollectionLabel(parent, withLocation: true)
                            .badge(0)
                            .labelStyle(.titleAndIcon)
                            .controlSize(.small)
                            .fixedSize()
                    } else {
                        Text("None")
                    }
                }
            }
                .proEnabled()
            
            if !collection.isNew {
                Section {
                    LabeledContent("Sharing") {
                        NavigationLink {
                            CollectionSharing($collection)
                        } label: {
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
                    .listItemTint(.monochrome)
            }
        } footer: {
            ProGroup {} free: {
                Text("Only available with Pro plan")
                    .onAppear {
                        if collection.isNew {
                            collection.parent = nil
                        }
                    }
            }
        }
    }
}

