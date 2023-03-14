import SwiftUI
import UI
import API

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
                TextField("", text: $collection.title, prompt: Text("Title"))
                    .fontWeight(.semibold)
                    .focused(focus, equals: .title)
                
                Icon(collection: $collection)
            }
            
            TextField("", text: $collection.description, prompt: Text("Description"), axis: .vertical)
                .preventLineBreaks(text: $collection.description)
                .lineLimit(2...)
        }
        
        Section {
            NavigationLink {
                CollectionParent($collection)
            } label: {
                if let parent = collection.parent {
                    CollectionLabel(parent, withLocation: true)
                        .badge(0)
                } else {
                    Text("None")
                        .foregroundStyle(.secondary)
                }
            }
                .proEnabled()
        } header: {
            Text("Parent")
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
        
        if !collection.isNew {
            Section {
                NavigationLink {
                    CollectionSharing($collection)
                } label: {
                    HStack {
                        Text("Sharing")
                        Spacer()
                        
                        if collection.public {
                            Text("Public")
                                .circularBadge()
                                .tint(.accentColor)
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
    }
}

