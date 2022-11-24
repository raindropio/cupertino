import SwiftUI
import API
import UI

struct BrowseItem: View {
    var raindrop: Raindrop
    var view: CollectionView
    
    init(_ raindrop: Raindrop, view: CollectionView) {
        self.raindrop = raindrop
        self.view = view
    }

    var body: some View {
        let cover = Rest.renderImage(
            raindrop.cover ?? raindrop.link,
            options: .maxDeviceSize
        )
        
        switch view {
        case .list:
            HStack(alignment: .top, spacing: 14) {
                Thumbnail(cover, width: 80, height: 60, cornerRadius: 3)
                    .padding(.top, 8)
                Details(raindrop: raindrop)
            }
            
        case .simple:
            HStack(alignment: .top, spacing: 14) {
                Thumbnail(raindrop.favicon, width: 20, height: 20, cornerRadius: 3)
                    .padding(.top, 8)
                Details(raindrop: raindrop)
            }
            
        case .grid:
            VStack(alignment: .leading, spacing: 0) {
                Thumbnail(cover, width: 250, aspectRatio: 1.333)
                    .frame(maxWidth: .infinity)
                Details(raindrop: raindrop, vertical: true)
            }
            
        case .masonry:
            VStack(alignment: .leading, spacing: 0) {
                Thumbnail(cover, width: 250)
                    .frame(maxWidth: .infinity)
                Details(raindrop: raindrop, vertical: true)
            }
        }
    }
}
