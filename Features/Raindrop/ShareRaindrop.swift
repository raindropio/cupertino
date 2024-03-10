import SwiftUI
import API

public struct ShareRaindropLink: View, Equatable {
    var raindrops: [Raindrop]
    
    public init(_ raindrop: Raindrop) {
        self.raindrops = [raindrop]
    }
    
    public init(_ raindrops: [Raindrop]) {
        self.raindrops = raindrops
    }
    
    public var body: some View {
        if raindrops.count == 1, let raindrop = raindrops.first {
            ShareLink(item: raindrop.link, subject: .init(raindrop.title), message: .init(raindrop.note), preview: SharePreview(raindrop.title))
        } else {
            ShareLink(items: raindrops.map { $0.link })
        }
    }
}
