import SwiftUI
import API
import UI
import UniformTypeIdentifiers
import Features

struct AddPopover: View {
    @Environment(\.dismiss) private var dismiss
    @State private var items = [NSItemProvider]()
    @State private var kind: Kind?
    
    var collection: Int
    
    var home: some View {
        NavigationStack {
            Form {
                Web(items: $items)
                
                Section {
                    Button {
                        kind = .collection
                    } label: {
                        Label("Collection", systemImage: "folder").tint(.primary)
                    }
                        .listItemTint(.blue)
                    
                    Button {
                        kind = .media
                    } label: {
                        Label("Media", systemImage: Filter.Kind.type(.image).systemImage).tint(.primary)
                    }
                        .listItemTint(Filter.Kind.type(.image).color)
                    
                    Button {
                        kind = .document
                    } label: {
                        Label("File", systemImage: Filter.Kind.file.systemImage).tint(.primary)
                    }
                        .listItemTint(Filter.Kind.file.color)
                }
                
                Section {
                    SafariLink(destination: URL(string: "https://help.raindrop.io/mobile-app#save-from-browser")!) {
                        HStack {
                            Label("Add from apps", systemImage: "puzzlepiece.extension").tint(.primary)
                            Spacer()
                            Text("Recommended")
                                .circularBadge()
                                .tint(.tertiaryLabel)
                        }
                    }
                        .listItemTint(.monochrome)
                }
            }
                .environment(\.defaultMinListRowHeight, 46)
                .submitLabel(.done)
                .symbolVariant(.fill)
                .navigationTitle("Add")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
                    }
                }
        }
    }

    var body: some View {
        Group {
            if items.isEmpty {
                switch kind {
                case nil:
                    home
                    
                case .collection:
                    CollectionStack(.new(parent: collection > 0 ? collection : nil), content: CollectionForm.init)
                    
                case .media:
                    MediaPicker(selection: $items, matching: [.images, .videos])
                    
                case .document:
                    DocumentPicker(selection: $items, matching: addTypes)
                }
            } else {
                AddDetect(items) { loading, urls in
                    if loading {
                        ProgressView()
                    } else {
                        AddStack(urls, to: collection)
                    }
                }
            }
        }
            .transition(.opacity)
            .animation(.default, value: kind)
            .animation(.default, value: items.count)
            .presentationDetents(
                items.isEmpty ? [.large] : [.height(300), .large],
                selection: .constant(items.isEmpty ? .large : .height(300))
            )
            .presentationDragIndicator(.hidden)
    }
}

extension AddPopover {
    enum Kind {
        case collection
        case media
        case document
    }
}
