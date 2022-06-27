import SwiftUI
import API

struct DetailView: View {
    var section: SidebarSelection
    @Binding var path: NavigationPath
    
    func browse(_ page: SidebarSelection) -> some View {
        BrowserView(page: page)
            .contextAction(forSelectionType: Raindrop.self) {
                if $0.count == 1, let raindrop = $0.first {
                    path.append(raindrop)
                }
            }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            browse(section)
                .navigationDestination(for: Collection.self) {
                    browse(.collection($0))
                }
                .navigationDestination(for: Raindrop.self) {
                    RaindropView(raindrop: $0)
                }
        }
    }
}
