import SwiftUI
import API
import UI
import Common

struct SidebarScreen: View {
    @State private var selection = Set<FindBy>()
    @State private var search = ""
    
    var body: some View {
        FindByList(
            selection: $selection,
            search: search
        )
            .modifier(Toolbar())
            .modifier(Routing(selection: $selection))
            .fab(hidden: !isPhone)
    }
}
