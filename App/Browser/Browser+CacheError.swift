import SwiftUI
import API
import UI
import Features

extension Browser {
    struct CacheError: ViewModifier {
        @ObservedObject var page: WebPage
        @Binding var raindrop: Raindrop
        
        private var mode: Browse.Location.Mode {
            page.request?.attribute as? Browse.Location.Mode ?? .raw
        }

        func body(content: Content) -> some View {
            if mode == .cache && raindrop.cache?.status != .ready {
                EmptyState(
                    "No permanent copy",
                    message: raindrop.cache?.status?.title ?? "",
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
