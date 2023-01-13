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
                BrowseScreen(find: find)
                
            case .multi(let count):
                EmptyState("\(count) items") {
                    Image(systemName: "checklist.checked")
                } actions: {
                    Button("Cancel") { router.path = [.browse(.init(0))] }
                }
                
            case .preview(let url, let mode):
                PreviewScreen(url: url, mode: mode)
            }
        }
            .navigationSplitViewConfiguration(sidebarMin: 400)
            .collectionEvents()
            .tagEvents()
            .dropProvider()
            .fancySheet(isPresented: $router.spotlight, content: Spotlight.init)
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
