import SwiftUI
import API
import UI

public struct AddLinkStack {
    @EnvironmentObject private var dispatch: Dispatcher
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Bool
    
    @State var link: String = ""
    @State var collection: Int
    
    public init(_ link: String = "", collection: Int? = nil) {
        self._link = .init(initialValue: link)
        self._collection = .init(initialValue: collection ?? -1)
    }
}

extension AddLinkStack: View {
    private func submit() async throws {
        if let url = URL.detect(from: link) {
            try await dispatch(
                RaindropsAction.add(
                    url,
                    collection: collection
                )
            )
        }
        
        dismiss()
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("URL") {
                    TextField("", text: $link, prompt: Text("https://"))
                        .focused($focused)
                }
                
                Section("Save in") {
                    CollectionPicker(id: $collection, matching: .insertable)
                }
            }
                .onAppear {
                    //get from pasteboard
                    if link.isEmpty, let paste = UIPasteboard.general.url {
                        link = paste.absoluteString
                    }
                    //focus on field by default
                    focused = true
                }
                .navigationTitle("Add link")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        ActionButton("Create", action: submit)
                            .disabled(URL.detect(from: link) == nil)
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }
}
