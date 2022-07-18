import SwiftUI
import API

struct Sidebar: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        List(selection: $router.sidebar) {
            TreeItems {
                Route.browse($0, nil)
            }
            
            Section(header: Text("Filters")) {
                ForEach(Filter.preview) { filter in
                    Label(filter.title, systemImage: filter.systemImage)
                        .tint(filter.color)
                        .tag(Route.filter(filter))
                }
            }
            
            Section(header: Text("Tags")) {
                ForEach(Tag.preview) { tag in
                    Label(tag.id, systemImage: tag.systemImage)
                        .tag(Route.tag(tag))
                }
            }
        }
            .modifier(SidebarMenu())
            .modifier(SidebarToolbar())
            .modifier(TreeContext())
    }
}
