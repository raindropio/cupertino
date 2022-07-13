import SwiftUI
import API

struct RaindropsView<Header: View>: View {
    @Binding var search: SearchQuery
    @ViewBuilder var header: () -> Header

    @State private var selection = Set<Raindrop>()
    
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
