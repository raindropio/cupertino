import SwiftUI
import API
import UI

struct Browser {
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher
    
    @State private var raindrop = Raindrop.new()
    @State private var loading = false
    
    @ObservedObject var page: WebPage
    var start: WebRequest
}

extension Browser {
    private var stored: Raindrop {
        guard let url = page.url else { return .new() }
        return r.state.item(url) ?? .new(link: url)
    }
    
    private func lookup() async {
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
            .task(id: page.url) { await lookup() }
            //browser
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .modifier(Toolbar(page: page, raindrop: $raindrop))
            .modifier(PageError(page: page, raindrop: $raindrop))
            .modifier(WebHighlights(page: page, raindrop: $raindrop, loading: $loading))
            #if DEBUG
            .captureLogs(page)
            #endif
    }
}
