import SwiftUI
import API
import UI
import Common
import Backport

extension PreviewScreen {
    struct CacheError: ViewModifier {
        @EnvironmentObject private var app: AppRouter

        @ObservedObject var page: WebPage
        var mode: Mode
        var raindrop: Raindrop?

        func body(content: Content) -> some View {
            if !page.canGoBack && mode == .cache && raindrop?.cache?.status != .ready {
                EmptyState(
                    "No permanent copy",
                    message: raindrop?.cache?.status?.title ?? "Unknown error",
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
