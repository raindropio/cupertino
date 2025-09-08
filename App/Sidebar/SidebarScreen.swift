import SwiftUI
import API
import UI
import Features

struct SidebarScreen: View {
    @Environment(\.containerHorizontalSizeClass) private var sizeClass
    @State private var search = ""
    
    @Binding var selection: FindBy?
    
    var body: some View {
        FindByList(selection: $selection, search: search)
            .modifier(Toolbar())
            .modifier(Search(selection: $selection, search: $search))
            .dropProvider()
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(.inline)
            .scopeEditMode()
            #endif
    }
}
