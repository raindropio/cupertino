import SwiftUI
import API
import UI

public struct AddURLStack {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Bool
    
    @State var url: String = ""
    @State var collection: Int
    
    public init(_ url: String = "", collection: Int? = nil) {
        self._url = .init(initialValue: url)
        self._collection = .init(initialValue: collection ?? -1)
    }
}

extension AddURLStack: View {
    @ViewBuilder
    private var createButton: some View {
        let parsed = URL.detect(from: url)

        ActionButton("Create") {
            if let parsed {
                try await dispatch(
                    RaindropsAction.add(
                        parsed,
                        collection: collection
                    )
                )
            }
            
            dismiss()
        }
            .disabled(parsed == nil)
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("URL") {
                    TextField("", text: $url, prompt: Text("https://"))
                        .focused($focused)
                }
                
                Section("Save in") {
                    CollectionPicker(id: $collection, matching: .insertable)
                }
            }
                .onAppear {
                    //get from pasteboard
                    if url.isEmpty, let paste = UIPasteboard.general.url {
                        url = paste.absoluteString
                    }
                    //focus on field by default
                    focused = true
                }
                .navigationTitle("New bookmark")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        createButton
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}
