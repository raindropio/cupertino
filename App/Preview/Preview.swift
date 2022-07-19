import SwiftUI
import API
import UI

struct Preview: View {
    var raindrop: Raindrop
    
    @State private var tags: [String] = ["angular", "google"]
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: .constant(""))
                TextField("Description", text: .constant(""))
            }
            
            Section {
                TokenField(
                    $tags,
                    prompt: "Add tags...",
                    suggestions: ["angular", "backend", "books", "cd", "electron", "engineering", "fonts", "free", "icons", "inclusive", "invalid_cache", "invalid_parser", "ios", "javascript", "JSDoc"]
                ) {
                    Label("Tags", systemImage: "number")
                }
                    .autocorrectionDisabled(true)
                
                Button("reset") {
                    tags = []
                }
            }
        }
            .formStyle(.grouped)
            .scrollDismissesKeyboard(.never)
            .controlSize(.large)
            .navigationTitle(raindrop.title)
            .onSubmit(of: .text) {
                print("sibmit")
            }
    }
}
