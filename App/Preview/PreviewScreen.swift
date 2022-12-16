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
    private var request: WebRequest {
        let rewrite = {
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
        }()
        
        return .init(
            rewrite,
            canonical: url,
            caching: .returnCacheDataElseLoad,
            attribute: mode
        )
    }
}

extension PreviewScreen: View {
    var body: some View {        
        WebView(page, request: request)
            .modifier(Title())
            .modifier(Action())
            .modifier(Toolbar(highlightsList: $highlightsList))
            .modifier(WebHighlights())
            .modifier(PageError())
            .modifier(CacheError())
            .environmentObject(page)
    }
}
