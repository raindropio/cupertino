import SwiftUI
import API
import UI
import Features

extension SidebarScreen {
    struct Toolbar: ViewModifier {
        @Environment(\.containerHorizontalSizeClass) private var sizeClass
        
        func body(content: Content) -> some View {
            content
            #if canImport(UIKit)
            .meNavigationTitle()
            .navigationBarTitleDisplayMode(isPhone ? .automatic : .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    DeepLink(.settings()) {
                        MeLabel()
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItemGroup {
                    Menu {
                        Section { CollectionsMenu() }
                        Section { TagsMenu() }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            #endif
        }
    }
}
