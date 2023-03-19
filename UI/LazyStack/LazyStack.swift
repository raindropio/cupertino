import SwiftUI

public struct LazyStack<Content: View, ID: Hashable, Menu: View> {
    var layout: LazyStackLayout
    @Binding var selection: Set<ID>
    var action: ((ID) -> Void)?
    var contextMenu: (Set<ID>) -> Menu

    var content: () -> Content
    
    public init(
        _ layout: LazyStackLayout,
        selection: Binding<Set<ID>>,
        action: ((ID) -> Void)? = nil,
        @ViewBuilder contextMenu: @escaping (Set<ID>) -> Menu,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.layout = layout
        self._selection = selection
        self.action = action
        self.contextMenu = contextMenu
        self.content = content
    }
}

extension LazyStack: View {
    private func itemTap(_ selection: Set<ID>) {
        if let id = selection.first {
            action?(id)
        }
    }
    
    public var body: some View {
        Group {
            switch layout {
            case .list:
                List(selection: $selection) {
                    content()
                        #if canImport(AppKit)
                        .listRowInsets(.init(top: 6, leading: 4, bottom: 6, trailing: 4))
                        #endif
                }
                    .listStyle(.plain)
                    .contextMenu(forSelectionType: ID.self, menu: contextMenu, primaryAction: itemTap)
                
            case .grid(_, _):
                GridScrollView(content: content)
                    .listSelectionBehaviour(selection: $selection)
                    .listContextMenuBehaviour(forSelectionType: ID.self, menu: contextMenu, primaryAction: itemTap)
            }
        }
            .environment(\.lazyStackLayout, layout)
            .id(layout == .list)
    }
}
