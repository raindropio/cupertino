import SwiftUI
import API
import UI

struct Preview: View {
    var raindrop: Raindrop.ID
    
    @State private var tags: [String] = ["angular", "google"]
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: .constant(""))
                TextField("Description", text: .constant(""))
            }
            
            Section {
                MultiPicker(selection: $tags, prompt: "Add tags...") { filter in
                    ForEach(Tag.preview) {
                        Text($0.id)
                    }
                } label: {
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
            .navigationTitle("Edit")
            .onSubmit(of: .text) {
                print("sibmit")
            }
    }
}
