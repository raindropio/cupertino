import SwiftUI
import API

struct Sidebar: View {
    @EnvironmentObject private var router: Router
    
    private static var filter = Filter(key: "type", value: "article")
    private static var filter2 = Filter(key: "type", value: "image")
    
    var body: some View {
        List(selection: $router.sidebar) {
            TreeItems {
                Route.browse($0, nil)
            }
            
            Label(Self.filter.title, systemImage: Self.filter.systemImage)
                .tag(Route.filter(Self.filter))
            
            Label(Self.filter2.title, systemImage: Self.filter2.systemImage)
                .tag(Route.filter(Self.filter2))
        }
            .modifier(SidebarMenu())
            .modifier(SidebarToolbar())
            .modifier(TreeContext())
    }
}
