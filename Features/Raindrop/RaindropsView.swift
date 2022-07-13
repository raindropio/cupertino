import SwiftUI
import API

struct RaindropsView<Header: View>: View {
    @Binding var selection: Set<Raindrop>
    @ViewBuilder var header: () -> Header
    
    var body: some View {
        List(selection: $selection) {
            header()
            
            Section {
                ForEach(Raindrop.preview) { raindrop in
                    Label(raindrop.title, systemImage: "bookmark")
                        .tag(raindrop)
                }
            }
        }
    }
}
