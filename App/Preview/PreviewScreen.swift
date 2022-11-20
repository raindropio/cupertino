import SwiftUI
import API
import UI

struct PreviewScreen: View {
    @AppStorage(ReaderOptions.StorageKey) private var options = ReaderOptions()
    @Environment(\.colorScheme) private var colorScheme
    
    var raindrop: Raindrop
    @State var mode: Mode
    
    init(raindrop: Raindrop, mode: Mode? = nil) {
        self.raindrop = raindrop
        self._mode = State(initialValue: mode ?? .init(raindrop))
    }
    
    var body: some View {
        let page = WebPage({
            switch mode {
            case .article: return Rest.previewArticle(raindrop.link, options: options)
            case .embed: return Rest.previewEmbed(raindrop.link)
            case .cache: return Rest.raindropCacheLink(raindrop.id)
            case .raw: return raindrop.link
            }
        }())
        
        Render(
            page: page,
            raindrop: raindrop,
            mode: $mode
        )
            .id(raindrop).id(mode).id(options)
            .environment(
                \.colorScheme,
                 (mode == .article ? options.theme?.colorScheme : nil) ?? colorScheme
            )
    }
}

extension PreviewScreen {
    struct Render: View {
        @StateObject var page: WebPage
        var raindrop: Raindrop
        @Binding var mode: Mode
        
        var body: some View {
            WebView(page)
                .webViewError(page)
                .webViewProgressBar(page)
                .webViewPageToolbar(page, overrideURL: !page.canGoBack ? raindrop.link : nil)
                .webViewHidesBarsOnSwipe(page)
                .toolbarRole(.editor)
                .modifier(Title(page: page, mode: mode, raindrop: raindrop))
                .modifier(Action(page: page, raindrop: raindrop))
                .modifier(Toolbar(page: page, mode: $mode, raindrop: raindrop))
        }
    }
}
