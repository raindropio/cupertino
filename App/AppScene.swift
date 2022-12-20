import SwiftUI
import API
import UI
import Common

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @AppStorage("theme") private var theme: PreferredTheme = .default

    var body: some View {
        SplitView(path: $router.path) {
            SidebarScreen()
        } detail: { screen in
            switch screen {
            case .browse(let find):
                BrowseScreen(find: router.bind(find))
                
            case .preview(let url, let mode):
                PreviewScreen(url: url, mode: mode)
                
            case .filters:
                FiltersScreen()
            }
        }
            .navigationSplitViewConfiguration(sidebarMin: 400)
            .collectionActions()
            .dropProvider()
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
