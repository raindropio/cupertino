import SwiftUI
import API

@ViewBuilder
public func ShareRaindropLink(_ raindrop: Raindrop) -> some View {
    if raindrop.file != nil {
        ShareLink(item: raindrop, subject: .init(raindrop.title), message: .init(raindrop.note), preview: SharePreview(raindrop.title))
    } else {
        ShareLink(item: raindrop.link, subject: .init(raindrop.title), message: .init(raindrop.note))
    }
}

@ViewBuilder
public func ShareRaindropLink(_ raindrops: [Raindrop]) -> some View {
    if raindrops.count == 1, let first = raindrops.first {
        ShareRaindropLink(first)
    } else {
        ShareLink(items: raindrops.map { $0.link })
    }
}
