import SwiftUI
import API
import UI
import Features

extension View {
    func addButton(hidden: Bool = false, to collection: Int = -1) -> some View {
        modifier(AB(hidden: hidden, collection: collection))
    }
}

fileprivate struct AB: ViewModifier {
    @Environment(\.drop) private var drop
    @EnvironmentObject private var c: CollectionSheet
    @Environment(\.isSearching) private var isSearching
    @Environment(\.editMode) private var editMode
    @State private var pickURL = false
    @State private var pickPhotos = false
    @State private var pickFiles = false

    var hidden: Bool
    var collection: Int
    
    private func add(_ items: [NSItemProvider]) {
        drop?(items, collection)
    }
    
    private var ignore: Bool {
        collection == -99 || isSearching || editMode?.wrappedValue == .active
    }

    func body(content: Content) -> some View {
        content
            .floatingActionButton(hide: hidden || ignore) {
                OptionalPasteButton(
                    supportedContentTypes: addTypes.filter { $0 != .text },
                    payloadAction: add
                )
                    .labelStyle(.iconOnly)
                    .buttonBorderShape(.capsule)
            }
            .toolbar {
                if !hidden, !ignore {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Menu {
                            Button { pickURL = true } label: {
                                Label("Web page", systemImage: "link")
                            }
                            
                            Section {
                                Button {
                                    c.create(collection > 0 ? collection : nil)
                                } label: {
                                    Label("Collection", systemImage: "folder")
                                }
                                
                                Button { pickPhotos = true } label: {
                                    Label("Media", systemImage: Filter.Kind.type(.image).systemImage)
                                }
                                
                                Button { pickFiles = true } label: {
                                    Label("File", systemImage: Filter.Kind.file.systemImage)
                                }
                            }
                            
                            Link(destination: URL(string: "https://help.raindrop.io/mobile-app#save-from-browser")!) {
                                Label("Add from apps", systemImage: "puzzlepiece.extension")
                            }
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                        }
                            .popover(isPresented: $pickURL) {
                                AddURL(action: add)
                            }
                    }
                }
            }
            .photoImporter(isPresented: $pickPhotos, onCompletion: add)
            .fileImporter(isPresented: $pickFiles, allowedContentTypes: addTypes, allowsMultipleSelection: true, onCompletion: add)
    }
}
