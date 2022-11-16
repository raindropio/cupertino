import SwiftUI
import API

struct EditRaindropScreen: View {
    @State var raindrop: Raindrop
    
    var body: some View {
        Form {
            TextField("Title", text: $raindrop.title)
        }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
    }
}
