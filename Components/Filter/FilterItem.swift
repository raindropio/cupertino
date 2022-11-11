import SwiftUI
import API

struct FilterItem: View, Equatable {
    var filter: Filter
    
    init(_ filter: Filter) {
        self.filter = filter
    }
    
    var body: some View {
        Label(filter.title, systemImage: filter.systemImage)
            .lineLimit(1)
            .symbolVariant(.fill)
            .tint(filter.color)
    }
}
