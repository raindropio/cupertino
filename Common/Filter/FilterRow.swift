import SwiftUI
import API

public struct FilterRow: View, Equatable {
    var filter: Filter
    
    public init(_ filter: Filter) {
        self.filter = filter
    }
    
    public var body: some View {
        Label(filter.title, systemImage: filter.systemImage)
            .lineLimit(1)
            .symbolVariant(.fill)
            .tint(filter.color)
    }
}
