import SwiftUI

struct Sidebar: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        List(selection: $router.sidebar) {
            TreeItems {
                Route.browse($0, "")
            }
        }
            .modifier(SidebarMenu())
            .modifier(SidebarToolbar())
            .modifier(TreeContext())
    }
}
