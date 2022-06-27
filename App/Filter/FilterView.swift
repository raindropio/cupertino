import SwiftUI
import API

struct FilterView: View {
    var filter: Filter
    @State private var selection = Set<Raindrop>()
    
    var body: some View {
        List(selection: $selection) {
            RaindropItems()
        }
            .listStyle(.inset)
            .navigationTitle(filter.title)
    }
}
