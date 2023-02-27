import SwiftUI
import UI
import API

extension CollectionForm {
    struct Fields {
        @Binding var collection: UserCollection
    }
}

extension CollectionForm.Fields: View {
    var body: some View {
        Section {
            HStack {
                TextField("Title", text: $collection.title)
                    .fontWeight(.semibold)
                    .autoFocus()
                
                Icon(collection: $collection)
            }
            
            TextField("Description", text: $collection.description, axis: .vertical)
                .preventLineBreaks(text: $collection.description)
                .lineLimit(2...)
        }
        
        Section("Parent") {            
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

