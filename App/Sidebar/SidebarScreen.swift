import SwiftUI
import API
import UI
import Features

struct SidebarScreen: View {
    @EnvironmentObject private var app: AppRouter
    
    var body: some View {
        FindByList(selection: $app.sidebar)
            .modifier(Toolbar())
            .dropProvider()
            .scopeEditMode()
            .navigationSplitViewColumnWidth(ideal: 450)
    }
}
