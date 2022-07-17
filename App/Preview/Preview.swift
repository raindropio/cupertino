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
                    "Tags",
                    value: $tags,
                    prompt: "Add tags...",
                    suggestions: ["a", "b", "c"]
                )
                    .autocorrectionDisabled(true)
                    .accentColor(.red)
                
                Button("reset") {
                    tags = []
                }
            }
        }
            .formStyle(.grouped)
            .navigationTitle(raindrop.title)
            .onSubmit(of: .text) {
                print("sibmit")
            }
    }
}
