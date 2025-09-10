import SwiftUI
import UI
import API
import Features

extension Folder.Toolbar {
    struct Regular: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @IsEditing private var isEditing

        @Binding var find: FindBy
        var pick: RaindropsPick
        var total: Int

        private var addPlacement: ToolbarItemPlacement {
            if #available(iOS 26.0, *) {
                .bottomBar
            } else {
                .automatic
            }
        }
        
        func body(content: Content) -> some View {
            content
                .toolbar {
                    if #available(iOS 26.0, *) {
                        DefaultToolbarItem(kind: .search, placement: .bottomBar)
                        ToolbarSpacer(placement: .bottomBar)
                    }
                    
                    if !isEditing {
                        ToolbarItem(placement: addPlacement) {
                            AddButton(collection: find.collectionId)
                                .tint(.accentColor)
                        }
                        
                        if total > 0 {
                            ToolbarItem {
                                EditButton("Select")
                                    .labelStyle(.titleOnly)
                            }
                            
                            if #available(iOS 26.0, *) {
                                ToolbarSpacer()
                            }
                        }
                        
                        if sizeClass == .regular {
                            ToolbarItem {
                                FilterRaindropsButton($find)
                            }
                            
                            if #available(iOS 26.0, *) {
                                ToolbarSpacer()
                            }
                        }
                        
                        ToolbarItemGroup(placement: .secondaryAction) {
                            if sizeClass == .compact {
                                FilterRaindropsButton($find)
                            }
                            
                            SortRaindropsButton(find)
                            ViewConfigRaindropsButton(find)
                            
                            Section {
                                CollectionsMenu(find.collectionId)
                            }
                        }
                    }
                }
        }
    }
}
