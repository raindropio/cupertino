import SwiftUI
import API

struct DetailView: View {
    @Binding var path: NavigationPath
    var page: BrowserPage
    
    func browse(_ page: BrowserPage) -> some View {
        BrowserView(page: page)
            .contextAction(forSelectionType: Raindrop.self) {
                if $0.count == 1, let raindrop = $0.first {
                    path.append(raindrop)
                }
            }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            browse(page)
                .navigationDestination(for: Collection.self) {
                    browse(.collection($0))
                }
                .navigationDestination(for: Raindrop.self) {
                    RaindropView(raindrop: $0)
                }
        }
    }
}
