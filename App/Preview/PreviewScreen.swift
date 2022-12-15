import SwiftUI
import API
import UI
import Common

struct PreviewScreen {
    @EnvironmentObject private var r: RaindropsStore
    @StateObject private var page = WebPage()
    @AppStorage(ReaderOptions.StorageKey) private var reader = ReaderOptions()
    @State private var highlightsList = false

    var url: URL
    var mode: Mode
}

extension PreviewScreen {
    private var rewrite: URL {
        switch mode {
        case .article:
            return Rest.previewArticle(url, options: reader)
        case .embed:
            return Rest.previewEmbed(url)
        case .cache:
            if let id = r.state.item(url)?.id {
                return Rest.raindropCacheLink(id)
            }
        case .raw: break
        }
        return url
    }
    
    private var currentMode: Mode {
        //TODO: rewrite to not use cangoback, just compare REAL url with rewrite url
        page.canGoBack ? .raw : mode
    }
}

extension PreviewScreen: View {
    var body: some View {
        WebView(page, url: rewrite, canonical: url)
            .modifier(PageError())
            .modifier(CacheError(mode: currentMode))
            .modifier(Action())
            .modifier(Title(mode: currentMode))
            .modifier(Toolbar(highlightsList: $highlightsList))
            .modifier(WebHighlights())
            .environmentObject(page)
    }
}
