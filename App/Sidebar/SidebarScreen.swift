import SwiftUI
import API
import UI
import Features

struct SidebarScreen: View {
    @Environment(\.containerHorizontalSizeClass) private var sizeClass
    @EnvironmentObject private var app: AppRouter
    
    var body: some View {
        FindByList(selection: $app.sidebar)
            .modifier(Toolbar())
            .fab(hidden: sizeClass == .regular)
            .scopeEditMode()
            .navigationSplitViewColumnWidth(ideal: 450)
    }
}
