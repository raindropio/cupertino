import SwiftUI
import API

struct TagView: View {
    var tag: Tag
    @State private var selection = Set<Raindrop>()
    
    var body: some View {
        List(selection: $selection) {
            RaindropItems()
        }
            .listStyle(.inset)
            .navigationTitle(tag.title)
    }
}
