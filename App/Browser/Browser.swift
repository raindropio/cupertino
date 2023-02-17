import SwiftUI
import API
import UI

struct Browser {
    @StateObject private var page = WebPage()
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    
    @State private var raindrop = Raindrop.new()
    @State private var loading = false
    
    var start: WebRequest
}

extension Browser {
    private var stored: Raindrop {
        guard let url = page.url else { return .new() }
        return r.state.item(url) ?? .new(link: url)
    }
    
    @Sendable private func lookup() async {
        defer { loading = false }
        guard let url = page.url else { return }
        loading = true
        try? await dispatch(RaindropsAction.lookup(url))
    }
}

extension Browser: View {
    var body: some View {
        WebView(page, request: start)
            //raindrop
            .task(id: stored) { raindrop = stored }
            .task(id: page.url, lookup)
            //browser
            .modifier(Title(page: page, raindrop: $raindrop))
            .modifier(Toolbar(page: page, raindrop: $raindrop))
            .modifier(CacheError(page: page, raindrop: $raindrop))
            .modifier(PageError(page: page, raindrop: $raindrop))
            .modifier(WebHighlights(page: page, raindrop: $raindrop, loading: $loading))
    }
}
