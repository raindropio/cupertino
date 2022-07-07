import SwiftUI
import API

struct RaindropView: View {
    var raindrop: Raindrop
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: .constant(raindrop.title), prompt: Text("Enter title"), axis: .vertical)
                    .lineLimit(3)
                TextField("Description", text: .constant(""), prompt: Text("Enter description"), axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
            .formStyle(.grouped)
            .navigationTitle("Raindrop")
    }
}
