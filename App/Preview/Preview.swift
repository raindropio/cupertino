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
                TokenField("Tags", value: $tags, prompt: "Add tags...") { text in
                    [.section("Recent"), .text("a"), .text("b"), .section("Other"), .text("c"), .text("d"), .text("e"), .text("f"), .text("g"), .text("h"), .text("e"), .text("j"), .text("k"), .text("l"), .text("m"), .text("n")]
                }
                    .autocorrectionDisabled(true)
            }
        }
            .formStyle(.grouped)
            .navigationTitle(raindrop.title)
    }
}
