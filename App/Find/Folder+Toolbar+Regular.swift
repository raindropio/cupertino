import SwiftUI
import UI
import API
import Features

extension Folder.Toolbar {
    struct Regular: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @IsEditing private var isEditing

        var find: FindBy
        var pick: RaindropsPick
        var toggleAll: () -> Void
        
        func body(content: Content) -> some View {
            content
                #if canImport(UIKit)
                .toolbarRole(.browser)
                #endif
                .toolbar {
                    if !isEditing {
                        ToolbarItemGroup {
                            if sizeClass == .regular {
                                SortRaindropsButton(find)
                                ViewConfigRaindropsButton(find)
                                Spacer()
                            }
                        }
                    
                        ToolbarItemGroup(placement: .primaryAction) {
                            AddButton(collection: find.collectionId)
                            if sizeClass == .regular {
                                Spacer()
                            }
                        }
                    }
                    
                    if !find.isSearching {
                        ToolbarTitleMenu {
                            CollectionsMenu(find.collectionId)
                        }
                    }
                }
        }
    }
}
