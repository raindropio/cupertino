import SwiftUI
import API
import UI

extension SidebarScreen {
    struct Phone: ViewModifier {
        @State private var find = FindBy()

        func body(content: Content) -> some View {
            if isPhone {
                Group {
                    if find.isSearching {
                        BrowseList(find: find)
                    } else {
                        content
                    }
                }
                    .fab()
                    .globalSearch(find: $find)
            } else {
                content
            }
        }
    }
}
