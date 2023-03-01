import SwiftUI
import API
import UI
import Features

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @AppStorage("theme") private var theme: PreferredTheme = .default
    @SceneStorage("column-visibility") private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    @ViewBuilder
    private func screen(_ path: AppRouter.Path) -> some View {
        switch path {
        case .find(let find): Find(find: find)
        case .preview(let find, let id): Preview(find: find, id: id)
        case .cached(let id): Cached(id: id)
        case .browse(let url): Browse(url: url)
        }
    }

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: SidebarScreen.init
        ) {
            NavigationStack(path: $router.detail) {
                Group {
                    if let space = router.sidebar {
                        Find(find: space)
                    }
                }
                .navigationDestination(for: AppRouter.Path.self, destination: screen)
            }
        }
            .navigationSplitViewUnlimitedWidth()
            .containerSizeClass()
            .collectionSheets()
            .tagSheets()
            .modifier(AppDeepLinks())
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
