import SwiftUI
import API

struct RaindropView: View {
    var raindrop: Raindrop
    
    var body: some View {
        Text(raindrop.title)
            .navigationTitle("Raindrop")
    }
}
