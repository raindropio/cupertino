import SwiftUI
import API
import UI
import Features

struct SidebarScreen: View {
    @Environment(\.containerHorizontalSizeClass) private var sizeClass
    @Binding var selection: FindBy?
    
    var body: some View {
        FindByList(selection: $selection)
            .navigationBarTitleDisplayMode(.inline)
            .modifier(Toolbar())
            .addButton(hidden: sizeClass == .regular)
            .dropProvider()
            .scopeEditMode()
            .navigationSplitViewColumnWidth(ideal: 450)
    }
}
