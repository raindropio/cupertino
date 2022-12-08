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
                        Label {
                            Text("Collection").foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "folder").imageScale(.large)
                        }
                    }
                        .listItemTint(.blue)
                    
                    Button {
                        kind = .media
                    } label: {
                        Label {
                            Text("Photos or videos").foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "photo").imageScale(.large)
                        }
                    }
                        .listItemTint(Filter.Kind.type(.image).color)
                    
                    Button {
                        kind = .document
                    } label: {
                        Label {
                            Text("Files").foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "doc").imageScale(.large)
                        }
                    }
                        .listItemTint(Filter.Kind.type(.document).color)
                }
                
                Section {
                    NavigationLink(destination: Extension.init) {
                        Label {
                            Text("Add from apps")
                        } icon: {
                            Image(systemName: "puzzlepiece.extension").imageScale(.large)
                        }
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
