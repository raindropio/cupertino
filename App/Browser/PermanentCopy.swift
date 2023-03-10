import SwiftUI
import API
import UI

struct PermanentCopy: View {
    @StateObject private var page = WebPage()
    @EnvironmentObject private var r: RaindropsStore
    var id: Raindrop.ID
    
    private var raindrop: Raindrop {
        r.state.item(id) ?? .new()
    }
    
    private var request: WebRequest {
        .init(
            Rest.raindropCacheLink(id),
            canonical: raindrop.link,
            caching: .returnCacheDataElseLoad
        )
    }
    
    private var title: String {
        page.canGoBack ? (page.url?.host() ?? "") : "Permanent copy"
    }
    
    var body: some View {
        if raindrop.cache?.status != .ready {
            EmptyState(
                "No permanent copy",
                message: Text(raindrop.cache?.status?.title ?? ""),
                icon: {
                    Image(systemName: "icloud.slash")
                        .foregroundStyle(.red)
                }
            )
        } else {
            Browser(page: page, start: request)
                .navigationTitle(title)
        }
    }
}
