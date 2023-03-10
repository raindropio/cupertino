import SwiftUI
import API
import UI
import Features

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @SceneStorage("column-visibility") private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    @ViewBuilder
    private func screen(_ path: AppRouter.Path) -> some View {
        switch path {
        case .find(let find): Find(find: find)
        case .preview(let find, let id): Preview(find: find, id: id)
        case .cached(let id): PermanentCopy(id: id)
        case .browse(let url): Browse(url: url)
        }
    }

    var body: some View {        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarScreen(selection: $router.sidebar)
        } detail: {
            NavigationStack(path: $router.path) {
                Group {
                    if let sidebar = router.sidebar {
                        Find(find: sidebar)
                    }
                }
                    .navigationDestination(for: AppRouter.Path.self, destination: screen)
            }
                //fix title appearance on iOS <=16.3
                .toolbarTitleMenu{}.id(isPhone ? router.sidebar : nil)
        }
            .navigationSplitViewUnlockSize()
            .navigationSplitViewPhoneStack()
            .navigationSplitViewFixStateReset()
            .navigationSplitViewStyle(.balanced)
            .containerSizeClass()
            .collectionSheets()
            .tagSheets()
            .modifier(AppDeepLinks())
            .environmentObject(router)
            .restoreSceneValue("app-sidebar", value: $router.sidebar)
            .restoreSceneValue("app-path", value: $router.path)
    }
}
