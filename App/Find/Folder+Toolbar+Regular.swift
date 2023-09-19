import SwiftUI
import UI
import API
import Features

extension Folder.Toolbar {
    struct Regular: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        @IsEditing private var isEditing
        @Environment(\.isSearching) private var isSearching

        var find: FindBy
        var pick: RaindropsPick
        
        @ViewBuilder
        private func secondaries() -> some View {
            SortRaindropsButton(find)
            ViewConfigRaindropsButton(find)
        }
        
        func body(content: Content) -> some View {
            content
                #if canImport(UIKit)
                .toolbarRole(.browser)
                #endif
                .toolbar {
                    if !isEditing {
                        ToolbarItemGroup(placement: sizeClass == .compact ? .secondaryAction : .automatic, content: secondaries)
                    }
                    
                    if isSearching, sizeClass == .compact {
                        ToolbarItem(placement: .bottomBar) {
                            Menu(content: secondaries) {
                                Image(systemName: "ellipsis.circle")
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .primaryAction) {
                        AddButton(collection: find.collectionId)
                            .disabled(isEditing)
                    }
                    
                    if sizeClass == .compact {
                        ToolbarItemGroup(placement: .secondaryAction) {
                            Section {
                                CollectionsMenu(find.collectionId)
                            }
                        }
                    } else {
                        ToolbarItemGroup {
                            Menu {
                                CollectionsMenu(find.collectionId)
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                        }
                    }
                }
        }
    }
}
