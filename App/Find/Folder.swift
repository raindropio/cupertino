import SwiftUI
import Features
import API
import UI

struct Folder<H: View>: View {
    @State private var selection: Set<Raindrop.ID> = .init()
    
    var find: FindBy
    var compact = false
    @ViewBuilder var header: () -> H
    
    var body: some View {
        RaindropsContainer(find, selection: $selection) {
            header()
            
            if !compact {
                RaindropItems(find)
                LoadMoreRaindropsButton(find)
            }
        }
            .modifier(Title(find: find))
            .modifier(Toolbar(find: find, selection: $selection))
            .raindropSheets()
            .pasteCommands(to: find.collectionId)
            #if canImport(UIKit)
            .scopeEditMode()
            #endif
            .onChange(of: find) { _ in
                selection = .init()
            }
    }
}
