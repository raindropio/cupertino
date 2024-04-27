import SwiftUI
import API
import UI

struct PrefetchRaindropsCovers: ViewModifier {
    @EnvironmentObject private var r: RaindropsStore
    var find: FindBy
    
    func body(content: Content) -> some View {
        content
            .modifier(Memorized(items: r.state.items(find)))
    }
}

extension PrefetchRaindropsCovers {
    fileprivate struct Memorized: ViewModifier {
        var items: [Raindrop]
        
        func body(content: Content) -> some View {
            content
                .prefetchThumbnails(items: items) {
                    Rest.renderImage(
                        $0.cover ?? $0.link,
                        options: .optimalSize
                    )
                }
        }
    }
}
