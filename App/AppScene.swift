import SwiftUI
import API
import UI
import Common

struct AppScene: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        NavigationPanes(path: $router.path) {
            SidebarScreen()
        } detail: { screen in
            switch screen {
            case .browse(let find):
                BrowseScreen(find: router.bind(find))
                
            case .preview(let raindrop, let mode):
                PreviewScreen(raindrop: raindrop, mode: mode)
                
            case .none:
                Text("bla")
            }
        }
            .collectionActions()
            .environmentObject(router)
    }
}
