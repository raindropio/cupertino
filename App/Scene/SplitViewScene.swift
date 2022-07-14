import SwiftUI

struct SplitViewScene: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        NavigationSplitView {
            Sidebar()
                #if os(iOS)
                .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .pad ? .inline : .automatic)
                #endif
        } detail: {
            RouterView(index: router.sidebar)
                #if os(iOS)
                .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .pad ? .inline : .automatic)
                #endif
        }
    }
}
