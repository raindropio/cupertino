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
                        Image(systemName: "person.crop.circle")
                    }
                }
                
                if sizeClass == .compact {
                    ToolbarItem(placement: .primaryAction) {
                        AddButton()
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
