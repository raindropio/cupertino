import SwiftUI
import API
import UI

extension RaindropsList {
    struct Toolbar: ViewModifier {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        var find: FindBy
        
        func body(content: Content) -> some View {
            content
                .toolbar {
                    ToolbarItemGroup {
                        if !isPhone {
                            RaindropsSort(find: find)
                            RaindropsView(find: find)
                        }
                    }
                }
        }
    }
}
