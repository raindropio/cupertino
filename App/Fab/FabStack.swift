import SwiftUI
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
                        Label("Photo & Video", systemImage: "photo").tint(.primary)
                    }
                        .listItemTint(.green)
                    
                    Button {
                        kind = .document
                    } label: {
                        Label("Files", systemImage: "doc").tint(.primary)
                    }
                        .listItemTint(.indigo)
                }
                
                Section {
                    NavigationLink(destination: Extension.init) {
                        Label("Add from apps", systemImage: "puzzlepiece.extension")
                    }
                        .tint(.secondary)
                }
            }
                .symbolVariant(.fill)
                .imageScale(.large)
                .navigationTitle("Add")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss.callAsFunction)
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
                        ProgressView().progressViewStyle(.circular)
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
