import SwiftUI
import API
import UI
import Features

struct SidebarScreen: View {
    @EnvironmentObject private var app: AppRouter
    @State private var search = ""
    
    var body: some View {
        FindByList(
            selection: $app.find,
            search: search
        )
            .modifier(Toolbar())
            .fab(hidden: !isPhone)
            .scopeEditMode()
            .navigationSplitViewColumnWidth(ideal: 450)
    }
}
