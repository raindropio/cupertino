import SwiftUI
import API
import UI

extension AddStack {
    struct NewLink {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.dismiss) private var dismiss
        @FocusState private var focused: Bool
        
        @State var link: String = ""
        var collection: Int
        
        init(_ link: String = "", collection: Int? = nil) {
            self._link = .init(initialValue: link)
            self.collection = collection ?? -1
        }
    }
}

extension AddStack.NewLink: View {
    private var isValid: Bool {
        URL.detect(from: link) != nil
    }
    
    private func start() {
        //get from pasteboard
        if link.isEmpty, let paste = UIPasteboard.general.url {
            link = paste.absoluteString
        }
        //focus on field by default
        focused = true
    }
    
    private func submit() async throws {
        guard isValid else { return }
        
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
        NavigationView {
            Form {
                Section("URL") {
                    TextField("", text: $link, prompt: Text("https://"))
                        .focused($focused)
                }
                
                SubmitButton("Add")
                    .disabled(!isValid)
            }
                .onAppear(perform: start)
                .onSubmit(submit)
                .navigationTitle("New link")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", action: dismiss.callAsFunction)
                    }
                }
        }
            .navigationViewStyle(.stack)
    }
}
