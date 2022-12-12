import SwiftUI
import API
import UI

struct PreviewScreen {
    @EnvironmentObject private var r: RaindropsStore
    @StateObject private var page = WebPage()
    @AppStorage(ReaderOptions.StorageKey) private var reader = ReaderOptions()

    var id: Raindrop.ID
    var mode: Mode?
}

extension PreviewScreen {
    private var raindrop: Raindrop? {
        if !page.canGoBack {
            return r.state.item(id)
        } else if let url = page.url {
            return r.state.item(url)
        }
        return nil
    }
    
    private var startMode: Mode {
        if let mode { return mode }
        if let raindrop = r.state.item(id) { return .init(raindrop) }
        return .raw
    }
    
    private var startURL: URL? {
        guard let raindrop = r.state.item(id) else { return nil }
        
        switch startMode {
        case .article: return Rest.previewArticle(raindrop.link, options: reader)
        case .embed: return Rest.previewEmbed(raindrop.link)
        case .cache: return Rest.raindropCacheLink(raindrop.id)
        case .raw: return raindrop.link
        }
    }
}

extension PreviewScreen: View {
    var body: some View {
        WebView(page, url: startURL)
            .backport.toolbarRole(.editor)
            .backport.toolbar(page.prefersHiddenToolbars ? .hidden : .automatic, for: .navigationBar, .tabBar, .bottomBar)
            .animation(.default, value: page.prefersHiddenToolbars)
            .modifier(PageError(page: page))
            .modifier(Action(page: page, raindrop: raindrop))
            .modifier(Title(page: page, mode: mode ?? startMode, raindrop: raindrop))
            .modifier(Toolbar(page: page, raindrop: raindrop))
    }
}
