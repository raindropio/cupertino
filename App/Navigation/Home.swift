import SwiftUI
import UI

struct Home: View {
    @State private var selection: Set<SidebarSelection> = [.collection(.Preview.items.first!)]
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            ZStack {
                if let page = selection.first {
                    Detail(section: page, path: $path)
                }
            }
        }
            .onChange(of: selection) { _ in
                path.removeLast(path.count)
            }
    }
}
