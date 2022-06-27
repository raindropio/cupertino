import SwiftUI
import API

struct RaindropItems: View {
    var body: some View {
        ForEach(Raindrop.preview) { raindrop in
            Label(raindrop.title, systemImage: "bookmark")
                .tag(raindrop)
        }
    }
}
