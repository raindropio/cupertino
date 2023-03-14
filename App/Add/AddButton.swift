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
    #if canImport(UIKit)
    @Environment(\.editMode) private var editMode
    #endif
    @State private var pickURL = false
    @State private var pickPhotos = false
    @State private var pickFiles = false

    var hidden: Bool
    var collection: Int
    
    private func add(_ items: [NSItemProvider]) {
        drop?(items, collection)
    }
    
    private var isEditing: Bool {
        #if canImport(UIKit)
        editMode?.wrappedValue == .active
        #else
        false
        #endif
    }
    
    private var ignore: Bool {
        collection == -99 || isEditing
    }

    func body(content: Content) -> some View {
        content
            #if canImport(UIKit)
            .overlay(alignment: .bottomTrailing) {
                if !hidden, !ignore, !isSearching {
                    OptionalPasteButton(
                        supportedContentTypes: addTypes.filter { $0 != .text },
                        payloadAction: add
                    )
                        .circlePasteButton()
                        .transition(.opacity)
                        .padding(.horizontal, 20)
                        .ignoresSafeArea(.keyboard)
                }
            }
            #endif
            .toolbar {
                if !hidden, !ignore {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Menu {
                            Button { pickURL = true } label: {
                                Label("Link", systemImage: "link")
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
                            
                            Section("Recommended") {
                                DeepLink(.settings(.extensions)) {
                                    Label("Install extension", systemImage: "puzzlepiece.extension")
                                }
                            }
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.medium)
                        }
                            .menuIndicator(.hidden)
                            .disabled(isSearching)
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
