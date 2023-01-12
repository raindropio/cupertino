import SwiftUI
import API
import UI

struct BrowseItem: View {
    var find: FindBy
    var raindrop: Raindrop
    var view: CollectionView

    var body: some View {
        let cover = Rest.renderImage(
            raindrop.cover ?? raindrop.link,
            options: .maxDeviceSize
        )
        
        switch view {
        case .list:
            HStack(alignment: .top, spacing: 14) {
                Thumbnail(cover, width: 80, height: 60)
                    .cornerRadius(3)
                    .padding(.top, 8)
                Details(find: find, raindrop: raindrop)
            }
            
        case .simple:
            HStack(alignment: .top, spacing: 14) {
                Thumbnail(raindrop.favicon, width: 20, height: 20)
                    .cornerRadius(3)
                    .padding(.top, 8)
                Details(find: find, raindrop: raindrop)
            }
            
        case .grid:
            VStack(alignment: .leading, spacing: 0) {
                Thumbnail(cover, width: 250, aspectRatio: 1.5)
                Details(find: find, raindrop: raindrop, vertical: true)
            }
            
        case .masonry:
            VStack(alignment: .leading, spacing: 0) {
                Thumbnail(cover, width: 250)
                Details(find: find, raindrop: raindrop, vertical: true)
            }
        }
    }
}
