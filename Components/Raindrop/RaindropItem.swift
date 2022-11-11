import SwiftUI
import API
import UI

struct RaindropItem: View {
    var raindrop: Raindrop
    var view: CollectionView

    var body: some View {
        switch view {
        case .list:
            HStack(alignment: .top, spacing: 14) {
                Thumbnail(raindrop.cover?.best, width: 80, height: 60, cornerRadius: 3)
                    .padding(.top, 8)
                RaindropDetails(raindrop: raindrop)
            }
            
        case .simple:
            HStack(alignment: .top, spacing: 14) {
                Thumbnail(raindrop.favicon, width: 20, height: 20, cornerRadius: 3)
                    .padding(.top, 8)
                RaindropDetails(raindrop: raindrop)
            }
            
        case .grid:
            VStack(alignment: .leading, spacing: 0) {
                Thumbnail(raindrop.cover?.best, width: 250, aspectRatio: 1.333)
                    .frame(maxWidth: .infinity)
                RaindropDetails(raindrop: raindrop, vertical: true)
            }
            
        case .masonry:
            VStack(alignment: .leading, spacing: 0) {
                Thumbnail(raindrop.cover?.best, width: 250)
                    .frame(maxWidth: .infinity)
                RaindropDetails(raindrop: raindrop, vertical: true)
            }
        }
    }
}
