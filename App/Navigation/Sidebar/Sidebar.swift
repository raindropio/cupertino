import SwiftUI

struct Sidebar: View {
    @Binding var selection: Set<SidebarSelection>

    var body: some View {
        List(selection: $selection) {
            TreeItems {
                SidebarSelection.collection($0)
            }
        }
            .modifier(SidebarMenu())
            .modifier(SidebarToolbar())
            .modifier(TreeContext())
    }
}
