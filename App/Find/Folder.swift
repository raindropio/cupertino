import SwiftUI
import Features
import API
import UI
import Backport

struct Folder: View {
    @State private var selection: Set<Raindrop.ID> = .init()
    
    @Binding var find: FindBy
    var compact = false
    
    var body: some View {
        RaindropsContainer(find, selection: $selection) {
            if !find.isSearching {
                Nesteds(find: find)
            }
            
            if !compact {
                RaindropItems(find)
                LoadMoreRaindropsButton(find)
            }
        }
            .modifier(SearchBar(find: $find))
            .backport.searchPresentationToolbarBehavior(.avoidHidingContent)
            .modifier(Title(find: find))
            .modifier(Toolbar(find: $find, selection: $selection))
            .raindropSheets()
            .pasteCommands(to: find.collectionId)
            #if canImport(UIKit)
            .scopeEditMode()
            #endif
            .onChange(of: find) { _ in
                selection = .init()
            }
            .dropProvider()
    }
}

struct FolderStateful: View {
    @State var find: FindBy

    var body: some View {
        Folder(find: $find)
    }
}
