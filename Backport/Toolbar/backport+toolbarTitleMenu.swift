import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder func toolbarTitleMenu<C: View>(@ViewBuilder _ menu: () -> C) -> some View {
        if #available(iOS 16, *) {
            content.toolbarTitleMenu(content: menu)
        } else {
            content
                .toolbar {
                    ToolbarItem {
                        Menu(content: menu) {
                            Image(systemName: "chevron.down.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .tint(.secondary)
                        }
                    }
                }
        }
    }
}
