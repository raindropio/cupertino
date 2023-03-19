import SwiftUI
import UI
import API
import Features

extension Folder.Toolbar {
    struct Regular: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.containerHorizontalSizeClass) private var sizeClass

        var find: FindBy
        var pick: RaindropsPick
        var toggleAll: () -> Void
        
        func body(content: Content) -> some View {
            content
                #if canImport(UIKit)
                .toolbarRole(.browser)
                #endif
                .toolbar {
                    ToolbarItemGroup {
                        if sizeClass == .regular {
                            SortRaindropsButton(find)
                            ViewConfigRaindropsButton(find)
                            Spacer()
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        AddButton(collection: find.collectionId)
                    }
                    
                    ToolbarTitleMenu {
                        if !find.isSearching {
                            CollectionsMenu(find.collectionId)
                        }
                    }
                }
        }
    }
}
