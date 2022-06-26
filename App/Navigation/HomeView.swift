import SwiftUI
import UI

struct HomeView: View {
    @State private var page: BrowserPage?
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(page: $page)
        } detail: {
            ZStack {
                if let page = page {
                    DetailView(path: $path, page: page)
                }
            }
        }
            .onChange(of: page) { _ in
                path.removeLast(path.count)
            }
    }
}
