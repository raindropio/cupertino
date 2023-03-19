import SwiftUI
import API
import UI
import Features

struct AddButton: View {
    @Environment(\.drop) private var drop
    @EnvironmentObject private var c: CollectionSheet
    @Environment(\.isSearching) private var isSearching
    @State private var pickURL = false
    @State private var pickPhotos = false
    @State private var pickFiles = false
    
    var collection: Int = -1
    
    private func add(_ items: [NSItemProvider]) {
        drop?(items, collection)
    }
    
    var body: some View {
        if collection != -99 {
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
                    
                    #if canImport(UIKit)
                    Button { pickPhotos = true } label: {
                        Label("Media", systemImage: Filter.Kind.type(.image).systemImage)
                    }
                    #endif
                    
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
                .labelStyle(.titleAndIcon)
                .help("Add")
                .menuIndicator(.hidden)
                .disabled(isSearching)
                .popover(isPresented: $pickURL) {
                    AddURL(action: add)
                }
                .photoImporter(isPresented: $pickPhotos, onCompletion: add)
                .fileImporter(isPresented: $pickFiles, allowedContentTypes: addTypes, allowsMultipleSelection: true, onCompletion: add)
        }
    }
}
