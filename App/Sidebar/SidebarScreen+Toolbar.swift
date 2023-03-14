import SwiftUI
import API
import UI
import Features

extension SidebarScreen {
    struct Toolbar: ViewModifier {
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        
        func body(content: Content) -> some View {
            content
            .meNavigationTitle()
            #if canImport(UIKit)
            .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    DeepLink(.settings()) {
                        MeLabel()
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItemGroup {
                    Menu {
                        //EditButton("Select")
                        Section { CollectionsMenu() }
                        Section { TagsMenu() }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                //edit mode
//                ToolbarItemGroup(placement: .bottomBar) {
//                    if !selection.isEmpty, editMode?.wrappedValue == .active {
//                        Group {
//                            if selection.allSatisfy({ !$0.isSearching }) {
//                                CollectionsMenu(selection)
//                            } else if selection.allSatisfy({ $0.isSearching }) {
//                                TagsMenu(selection)
//                            }
//                        }
//                            .labelStyle(.titleOnly)
//                    }
//                }
            }
        }
    }
}
