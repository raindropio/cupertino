import SwiftUI

public struct LazyStack<Content: View, ID: Hashable, Menu: View> {
    @StateObject private var model = LazyStackModel<ID>()
    
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
    public var body: some View {
        Group {
            switch layout {
            case .list:
                List(selection: $selection, content: content)
                    .contextMenu(forSelectionType: ID.self, menu: contextMenu) {
                        if let id = $0.first {
                            action?(id)
                        }
                    }
                
            case .grid(_, _):
                GridScrollView {
                    content()
                        #if canImport(UIKit)
                        .innerEditMode {
                            model.isEditing = $0.isEditing
                            
                            //reset selection on edit mode exit
                            if $0 == .inactive {
                                selection = .init()
                            }
                        }
                        #endif
                }
                    .task {
                        model.action = action
                        model.contextMenu = { AnyView(contextMenu($0)) }
                    }
            }
        }
            .task(id: selection) { model.selection = selection }
            .task(id: model.selection) { selection = model.selection }
            .environment(\.lazyStackLayout, layout)
            .environmentObject(model)
    }
}

