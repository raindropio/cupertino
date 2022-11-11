import SwiftUI
import API
import UI

struct AppScene: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        NavigationPanes(path: $router.path) {
            SidebarScreen()
        } detail: { screen in
            switch screen {
            case .browse(let find): BrowseScreen(find: router.bind(find))
            case .preview(let id): PreviewScreen(id: id)
            case .none: Text("bla")
            }
        }
            .collectionActions()
            .environmentObject(router)
    }
}
