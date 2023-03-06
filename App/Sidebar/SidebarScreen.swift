import SwiftUI
import API
import UI
import Features

struct SidebarScreen: View {
    @EnvironmentObject private var app: AppRouter
    @Environment(\.containerHorizontalSizeClass) private var sizeClass
    
    var body: some View {
        FindByList(selection: $app.sidebar)
            .modifier(Toolbar())
            .addButton(hidden: sizeClass == .regular)
            .dropProvider()
            .scopeEditMode()
            .navigationSplitViewColumnWidth(ideal: 450)
    }
}
