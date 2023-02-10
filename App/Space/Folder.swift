import SwiftUI
import Features
import API
import UI

struct Folder<H: View>: View {
    @Environment(\.isSearching) private var isSearching
    @State private var selection: Set<Raindrop.ID> = .init()
    
    var find: FindBy
    @ViewBuilder var header: () -> H
    
    var body: some View {
        RaindropsContainer(find, selection: $selection) {
            header()
            
            if isPhone {
                Status(find: find)
            }
            
            RaindropItems(find)
            LoadMoreRaindropsButton(find)
        }
            .fab(to: find.collectionId)
            .modifier(Title(find: find))
            .modifier(Toolbar(find: find, selection: $selection))
            .scopeEditMode()
    }
}
