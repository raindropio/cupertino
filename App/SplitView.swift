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
        case .find(let find): FolderStateful(find: find)
        case .preview(let find, let id): Preview(find: find, id: id)
        case .cached(let id): PermanentCopy(id: id)
        case .browse(let url): Browse(url: url)
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility, preferredCompactColumn: .constant(path.preferredCompactColumn)) {
            SidebarScreen(selection: $path.sidebar)
                .navigationSplitViewColumnWidth(min: 250, ideal: 450)
        } detail: {
            NavigationStack(path: $path.detail) {
                Group {
                    if path.sidebar != nil {
                        Folder(find: .init(get: { path.sidebar! }, set: { path.sidebar = $0 }))
                    }
                }
                .navigationDestination(for: SplitViewPath.Screen.self, destination: screen)
            }
        }
            .inspector(isPresented: $path.ask){
                Ask(path: $path)
                    .inspectorColumnWidth(min: 250, ideal: 450)
            }
            //auto hide sidebar / ask
            .onChange(of: path.ask) { _, next in
                if next {
                    columnVisibility = .detailOnly
                }
            }
            .onChange(of: columnVisibility) { _, next in
                if next != .detailOnly && path.ask {
                    path.ask = false
                }
            }
            //split view specific
            .navigationSplitViewUnlockSize()
            .containerSizeClass()
            //sheets
            .collectionSheets()
            .tagSheets()
            //pushes
            .modifier(PushNotifications())
            //routing
            .modifier(ReceiveDeepLink(path: $path))
            .restoreSceneValue("app-path", value: $path)
    }
}
