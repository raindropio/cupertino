import SwiftUI
import API
import UI
import UniformTypeIdentifiers
import Common

struct FabStack: View {
    @Environment(\.dismiss) private var dismiss
    @State private var items = [NSItemProvider]()
    @State private var kind: Kind?
    
    var collection: Int
    
    var home: some View {
        NavigationView {
            Form {
                Section("URL") {
                    Web(items: $items)
                }
                
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
                        Label("Photos or videos", systemImage: "photo").tint(.primary)
                    }
                        .listItemTint(Filter.Kind.type(.image).color)
                    
                    Button {
                        kind = .document
                    } label: {
                        Label("Files", systemImage: "doc").tint(.primary)
                    }
                        .listItemTint(Filter.Kind.type(.document).color)
                }
                
                Section {
                    NavigationLink(destination: Extension.init) {
                        Label("Add from apps", systemImage: "puzzlepiece.extension")
                    }
                        .tint(.secondary)
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
                    CollectionStack(collection > 0 ? .parent(collection) : .group())
                    
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
    }
}

extension FabStack {
    enum Kind {
        case collection
        case media
        case document
    }
}
