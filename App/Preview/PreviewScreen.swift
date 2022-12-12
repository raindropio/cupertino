import SwiftUI
import API
import UI

struct PreviewScreen: View {
    @EnvironmentObject private var r: RaindropsStore

    var id: Raindrop.ID
    var mode: Mode?

    var body: some View {
        if let raindrop = r.state.item(id) {
            Memorized(
                raindrop: raindrop,
                mode: mode ?? .init(raindrop)
            )
        }
    }
}

extension PreviewScreen {
    struct Memorized: View {
        @AppStorage(ReaderOptions.StorageKey) private var options = ReaderOptions()
        @StateObject private var page = WebPage()

        var raindrop: Raindrop
        @State var mode: Mode

        var body: some View {
            let url: URL = {
                switch mode {
                case .article: return Rest.previewArticle(raindrop.link, options: options)
                case .embed: return Rest.previewEmbed(raindrop.link)
                case .cache: return Rest.raindropCacheLink(raindrop.id)
                case .raw: return raindrop.link
                }
            }()

            WebView(page, url: url)
                .backport.toolbarRole(.editor)
                .modifier(Title(page: page, mode: mode, raindrop: raindrop))
                .modifier(Action(page: page, raindrop: raindrop))
                .modifier(Toolbar(page: page, mode: $mode, raindrop: raindrop))
        }
    }
}
