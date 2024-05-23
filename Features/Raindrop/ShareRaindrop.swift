import SwiftUI
import API
import UI

public struct ShareRaindropLink: View, Equatable {
    var raindrops: [Raindrop]
    
    public init(_ raindrop: Raindrop) {
        self.raindrops = [raindrop]
    }
    
    public init(_ raindrops: [Raindrop]) {
        self.raindrops = raindrops
    }
    
    public var body: some View {
        //file specific
        if raindrops.count == 1, let raindrop = raindrops.first, raindrop.file != nil {
            //ShareLink(item: raindrop, preview: SharePreview(raindrop.file?.name ?? "", image: Image(systemName: "cloud")))
            ShareRemoteFile(raindrop.link, fileName: raindrop.file?.name)
        } else {
            //crashing when copy share action on iOS 17 when using SharePreview - ShareLink(items: raindrops) { SharePreview($0.title) }
            ShareLink(items: raindrops.map { $0.link })
        }
    }
}
