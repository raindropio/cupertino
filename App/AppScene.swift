import SwiftUI
import API
import UI
import Features

struct AppScene: View {
    @StateObject private var router = AppRouter()
    @SceneStorage("column-visibility") private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    @ViewBuilder
    private func screen(_ path: AppRouter.Path?) -> some View {
        switch path {
        case .find(let find): Find(find: find)
        case .preview(let find, let id): Preview(find: find, id: id)
        case .cached(let id): Cached(id: id)
        case .browse(let url): Browse(url: url)
        case nil: Color.clear
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarScreen(selection: $router.sidebar)
        } detail: {
            NavigationStack(path: $router.detail) {
                screen(router.path.first)
                    .navigationDestination(for: AppRouter.Path.self, destination: screen)
            }
                //fix title appearance on iOS <=16.3
                .toolbarTitleMenu{}.id(router.path.first)
        }
            .navigationSplitViewPhoneStack()
            .navigationSplitViewUnlimitedWidth()
            .containerSizeClass()
            .collectionSheets()
            .tagSheets()
            .modifier(AppDeepLinks())
            .environmentObject(router)
    }
}
