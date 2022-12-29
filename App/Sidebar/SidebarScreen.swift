import SwiftUI
import API
import UI
import Common

struct SidebarScreen: View {
    @State private var selection = Set<FindBy>()
    @State private var search = ""
    
    var body: some View {
        FindByPicker(
            selection: $selection,
            search: search
        )
            .modifier(Me())
            .modifier(Phone(search: $search))
            .modifier(Routing(selection: $selection))
    }
}
