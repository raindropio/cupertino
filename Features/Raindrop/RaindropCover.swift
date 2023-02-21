import SwiftUI
import API
import UI

struct RaindropCover: View {
    var raindrop: Raindrop
    var view: CollectionView
    
    init(_ raindrop: Raindrop, view: CollectionView? = nil) {
        self.raindrop = raindrop
        self.view = view ?? .list
    }
    
    var body: some View {
        let cover = Rest.renderImage(
            raindrop.cover ?? raindrop.link,
            options: .maxDeviceSize
        )
        
        switch view {
        case .list:
            Thumbnail(cover, width: 80, height: 60)
            
        case .simple:
            Thumbnail(raindrop.favicon, width: 20, height: 20)
            
        case .grid:
            Thumbnail(cover, width: 250, aspectRatio: 1.5)
            
        case .masonry:
            Thumbnail(cover, width: 250)
        }
    }
}

extension RaindropCover: Equatable {}
