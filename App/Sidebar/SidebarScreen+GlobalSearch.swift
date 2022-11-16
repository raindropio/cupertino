import SwiftUI
import API
import UI

extension SidebarScreen {
    struct OptionalGlobalSearch<C: View>: View {
        @State private var find = FindBy()
        var content: () -> C
        
        var body: some View {
            if isPhone {
                Group {
                    if find.isSearching {
                        BrowseList(find: find)
                    } else {
                        content()
                    }
                }
                    .globalSearch(find: $find)
            } else {
                content()
            }
        }
    }
}
