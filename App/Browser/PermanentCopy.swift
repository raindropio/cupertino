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
        page.canGoBack ? (page.url?.host() ?? "") : String(localized: "Web archive")
    }
    
    var body: some View {
        if raindrop.cache?.status != .ready {
            EmptyState(
                "No web archive",
                message: Text(raindrop.cache?.status?.title ?? String(localized: "Web archive is not created yet")),
                icon: {
                    Image(systemName: "icloud.slash")
                        .foregroundStyle(.red)
                }
            ) {
                Link("Learn more", destination: URL(string: "https://help.raindrop.io/permanent-copy")!)
            }
        } else {
            Browser(page: page, start: request)
                .navigationTitle(title)
        }
    }
}
