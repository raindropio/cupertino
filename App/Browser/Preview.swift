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
    
    private var raindrop: Raindrop {
        r.state.item(id) ?? .new()
    }
    
    private var request: WebRequest {
        .init(
            {
                if raindrop.type.readable {
                    return Rest.raindropPreview(raindrop.id, options: reader)
                } else {
                    return raindrop.link
                }
            }(),
            canonical: raindrop.link
        )
    }
    
    private var title: String {
        guard
            let url = page.canGoBack ? page.url : raindrop.link,
            let host: String = url.host
        else { return "" }
        return host
    }
    
    var body: some View {
        Browser(page: page, start: request)
            .navigationTitle(title)
            .toolbar {
                if !page.canGoBack, raindrop.type.readable {
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
