import SwiftUI
import API
import UI
import Features

struct SidebarScreen: View {
    @Environment(\.containerHorizontalSizeClass) private var sizeClass
    @Binding var selection: FindBy?
    
    var body: some View {
        FindByList(selection: $selection)
            .modifier(Toolbar())
            .pasteCommands(enabled: sizeClass == .compact)
            .dropProvider()
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            .scopeEditMode()
            #endif
    }
}
