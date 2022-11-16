import SwiftUI
import API
import UI

extension BrowseList {
    struct Toolbar: ViewModifier {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        var find: FindBy
        
        func body(content: Content) -> some View {
            content
                .toolbar {
                    ToolbarItemGroup {
                        if !isPhone {
                            BrowseSortButton(find: find)
                            BrowseViewButton(find: find)
                        }
                    }
                }
        }
    }
}
