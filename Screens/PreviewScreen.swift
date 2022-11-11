import SwiftUI
import API

struct PreviewScreen: View {
    var id: Raindrop.ID
    
    var body: some View {
        Text("\(id)")
            .navigationTitle("Bla")
    }
}
