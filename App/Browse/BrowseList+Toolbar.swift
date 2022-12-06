import SwiftUI
import API
import UI

extension BrowseList {
    struct Toolbar: ViewModifier {
        @Environment(\.editMode) private var editMode
        var find: FindBy
        
        func body(content: Content) -> some View {
            if !isPhone {
                content
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Group {
                                BrowseSortButton(find: find)
                                BrowseViewButton(find: find)
                            }
                                .opacity(editMode?.wrappedValue == .active ? 0 : 1)
                        }
                    }
            } else {
                content
            }
        }
    }
}
