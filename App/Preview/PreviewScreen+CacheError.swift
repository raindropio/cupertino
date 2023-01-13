import SwiftUI
import API
import UI
import Features
import Backport

extension PreviewScreen {
    struct CacheError: ViewModifier {
        @EnvironmentObject private var page: WebPage
        @EnvironmentObject private var app: AppRouter
        @EnvironmentObject private var r: RaindropsStore
        
        var raindrop: Raindrop? {
            guard let url = page.url else { return nil }
            return r.state.item(url)
        }
        
        private var mode: PreviewScreen.Mode {
            page.request?.attribute as? PreviewScreen.Mode ?? .raw
        }

        func body(content: Content) -> some View {
            if mode == .cache && raindrop?.cache?.status != .ready {
                EmptyState(
                    "No permanent copy",
                    message: raindrop?.cache?.status?.title ?? "",
                    icon: {
                        Image(systemName: "icloud.slash")
                            .foregroundStyle(.red)
                    }
                )
            } else {
                content
            }
        }
    }
}
