import SwiftUI
import API
import UI
import Features

struct Preview: View {
    @StateObject private var page = WebPage()
    @EnvironmentObject private var r: RaindropsStore
    @AppStorage(ReaderOptions.StorageKey) private var reader = ReaderOptions()
    @State private var appearance = false

    var find: FindBy
    var id: Raindrop.ID
    
    private var request: WebRequest {
        let item = r.state.item(id) ?? .new()
        
        return .init(
            {
                switch item.type {
                case .link:
                    return item.link
                    
                default:
                    return Rest.raindropPreview(item.id, options: reader)
                }
            }(),
            canonical: item.link,
            caching: .returnCacheDataElseLoad
        )
    }
    
    private var title: String {
        page.canGoBack ? (page.url?.host() ?? "") : "Preview"
    }
    
    var body: some View {
        Browser(page: page, start: request)
            .navigationTitle(title)
            .toolbar {
                if !page.canGoBack {
                    ToolbarItemGroup {
                        Button { appearance.toggle() } label: {
                            Image(systemName: "textformat.size")
                        }
                        .popover(isPresented: $appearance, content: ReaderAppearance.init)
                    }
                }
            }
    }
}
