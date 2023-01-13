import SwiftUI
import API
import UI
import Features

extension BrowseItem {
    struct Details: View {
        var find: FindBy
        var raindrop: Raindrop
        var vertical = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                RaindropTitleExcerpt(raindrop)
                    .lineLimit(3)
                
                Buttons(find: find, raindrop: raindrop)
                
                if vertical {
                    Spacer(minLength: 0)
                }
                
                RaindropMeta(raindrop)
            }
                .frame(maxHeight: .infinity)
                .padding(vertical ? 12 : 0)
        }
    }
}
