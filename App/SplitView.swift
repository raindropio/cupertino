import SwiftUI
import API
import UI
import Features

struct SplitView: View {
    @State private var path = SplitViewPath()
    @SceneStorage("column-visibility") private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    @ViewBuilder
    private func screen(_ screen: SplitViewPath.Screen) -> some View {
        switch screen {
        case .find(let find): Find(find: find)
        case .preview(let find, let id): Preview(find: find, id: id)
        case .cached(let id): PermanentCopy(id: id)
        case .browse(let url): Browse(url: url)
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarScreen(selection: $path.sidebar)
                .navigationSplitViewColumnWidth(min: 250, ideal: 450)
        } detail: {
            NavigationStack(path: $path.detail) {
                Group {
                    if let sidebar = path.sidebar {
                        Find(find: sidebar)
                    }
                }
                    .navigationDestination(for: SplitViewPath.Screen.self, destination: screen)
            }
                //fix title appearance on iOS <=16.3
                .toolbarTitleMenu{}.id(isPhone ? path.sidebar : nil)
        }
            //split view specific
            .navigationSplitViewUnlockSize()
            .navigationSplitViewPhoneStack()
            .containerSizeClass()
            //sheets
            .collectionSheets()
            .tagSheets()
            //pushes
            .modifier(Pushes())
            //routing
            .modifier(ReceiveDeepLink(path: $path))
            .restoreSceneValue("app-path", value: $path)
    }
}
