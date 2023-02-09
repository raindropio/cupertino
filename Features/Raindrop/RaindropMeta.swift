import SwiftUI
import API
import UI

public struct RaindropMeta: View {
    var raindrop: Raindrop
    
    public init(_ raindrop: Raindrop) {
        self.raindrop = raindrop
    }
    
    public var body: some View {
        (
            (
                raindrop.type != .link ?
                    Text(Image(systemName: raindrop.type.systemImage)) + Text("\u{00a0}") :
                    Text("")
            )
            + Text(raindrop.domain)
            + Text("\u{00a0}• ")
            + Text(raindrop.created, formatter: .shortDateTime)
        )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(2)
            .symbolVariant(.fill)
            .imageScale(.small)
            .fixedSize(horizontal: false, vertical: true)
    }
}
