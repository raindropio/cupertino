import SwiftUI

struct SplitViewScene: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        NavigationSplitView {
            Sidebar()
        } detail: {
            RouterView(index: router.sidebar)
        }
    }
}
