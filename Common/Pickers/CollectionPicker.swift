import SwiftUI
import API

public struct CollectionPicker {
    @EnvironmentObject private var c: CollectionsStore
    
    @Binding var id: Int?
    var matching: CollectionsListMatching = .all
    var prompt: String
    
    init(id: Binding<Int?>, matching: CollectionsListMatching, prompt: String = "") {
        self._id = id
        self.matching = matching
        self.prompt = prompt
    }
    
    init(id: Binding<Int>, matching: CollectionsListMatching, prompt: String = "") {
        self._id = .init { id.wrappedValue } set: { id.wrappedValue = $0 ?? -1 }
        self.matching = matching
        self.prompt = prompt
    }
}

extension CollectionPicker: View {
    public var body: some View {
        NavigationLink {
            Page(id: $id, matching: matching)
                .navigationTitle(prompt)
        } label: {
            if let id, let collection = c.state.user[id] {
                UserCollectionRow(collection, withLocation: true)
            } else if let id, id < 0 {
                SystemCollectionRow(id: id)
            } else {
                Label(prompt, systemImage: "folder")
            }
        }
    }
}

extension CollectionPicker {
    struct Page: View {
        @Environment(\.dismiss) private var dismiss
        
        @Binding var id: Int?
        var matching: CollectionsListMatching = .all
        
        var body: some View {
            CollectionsList(selection: $id, matching: matching, searchable: true)
                .collectionActions()
                .onChange(of: id) { _ in
                    dismiss()
                }
        }
    }
}
