import SwiftUI
import API

public struct CollectionPicker<Prompt: View> {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var c: CollectionsStore
    
    @Binding var id: Int?
    var matching: CollectionsListMatching = .all
    var prompt: () -> Prompt
    
    init(id: Binding<Int?>, matching: CollectionsListMatching, prompt: @escaping () -> Prompt) {
        self._id = id
        self.matching = matching
        self.prompt = prompt
    }
}

extension CollectionPicker where Prompt == Label<Text, Image> {
    init(id: Binding<Int?>, matching: CollectionsListMatching, prompt: String = "") {
        self._id = id
        self.matching = matching
        self.prompt = { Label(prompt, systemImage: "folder") }
    }
    
    init(id: Binding<Int>, matching: CollectionsListMatching, prompt: String = "") {
        self._id = .init {
            id.wrappedValue
        } set: {
            let newValue = $0 ?? -1
            if newValue != id.wrappedValue {
                id.wrappedValue = newValue
            }
        }
        self.matching = matching
        self.prompt = { Label(prompt, systemImage: "folder") }
    }
}

extension CollectionPicker: View {
    public var body: some View {
        NavigationLink {
            Screen(id: $id, matching: matching)
                .navigationTitle("Collection")
        } label: {
            if let id, let collection = c.state.user[id] {
                UserCollectionRow(collection, withLocation: true)
            } else if let id, id < 0 {
                SystemCollectionRow(id: id)
            } else {
                prompt()
            }
        }
            .task(priority: .background) {
                try? await dispatch(CollectionsAction.load)
            }
    }
}

extension CollectionPicker {
    public struct Screen: View {
        @Environment(\.dismiss) private var dismiss
        
        @Binding var id: Int?
        var matching: CollectionsListMatching = .all
        
        public init(id: Binding<Int?>, matching: CollectionsListMatching) {
            self._id = id
            self.matching = matching
        }
        
        public var body: some View {
            CollectionsList(selection: $id, matching: matching, searchable: true)
                .collectionActions()
                .onChange(of: id) { _ in
                    dismiss()
                }
        }
    }
}
