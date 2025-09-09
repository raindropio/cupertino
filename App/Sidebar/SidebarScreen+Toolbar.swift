import SwiftUI
import API
import UI
import Features

extension SidebarScreen {
    struct Toolbar: ViewModifier {
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        
        private var addPlacement: ToolbarItemPlacement {
            if #available(iOS 26.0, *) {
                .bottomBar
            } else {
                .automatic
            }
        }
        
        func body(content: Content) -> some View {
            content
            #if canImport(UIKit)
            .meNavigationTitle()
            .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
            .toolbar {
                if #available(iOS 26.0, *) {
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                    ToolbarSpacer(placement: .bottomBar)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    DeepLink(.settings()) {
                        Image(systemName: "gearshape")
                    }
                }
                
                if sizeClass == .compact {
                    ToolbarItem(placement: addPlacement) {
                        AddButton()
                            .tint(.accentColor)
                    }
                }
                
                ToolbarItemGroup(placement: .secondaryAction) {
                    Section { CollectionsMenu() }
                    Section { TagsMenu() }
                }
            }
            #endif
        }
    }
}
