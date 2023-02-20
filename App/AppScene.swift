import SwiftUI
import API
import UI
import Features

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @AppStorage("theme") private var theme: PreferredTheme = .default

    var body: some View {
        NavigationSplitView(sidebar: SidebarScreen.init) {
            NavigationStack(path: $router.detail) {
                Group {
                    if let space = router.sidebar {
                        Find(find: space)
                    }
                }
                .navigationDestination(for: AppRouter.Path.self) {
                    switch $0 {
                    case .find(let find): Find(find: find)
                    case .preview(let find, let id): Preview(find: find, id: id)
                    case .cached(let id): Cached(id: id)
                    case .browse(let url): Browse(url: url)
                    }
                }
            }
        }
            .navigationSplitViewUnlimitedWidth()
            .containerSizeClass()
            .collectionSheets()
            .tagSheets()
            .dropProvider()
            .modifier(AppDeepLinks())
            .environmentObject(router)
            .preferredColorScheme(theme.colorScheme)
    }
}
