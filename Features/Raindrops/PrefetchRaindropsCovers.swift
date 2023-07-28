import SwiftUI
import API
import UI

struct PrefetchRaindropsCovers: ViewModifier {
    @EnvironmentObject private var r: RaindropsStore
    var find: FindBy
    
    func body(content: Content) -> some View {
        content
            .prefetchThumbnails(items: r.state.items(find)) {
                Rest.renderImage(
                    $0.cover ?? $0.link,
                    options: .optimalSize
                )
            }
    }
}
