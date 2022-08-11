import SwiftUI

public struct CollectionView<Content: View, ID: Hashable, Menu: View> {
    @StateObject private var model = CollectionViewModel<ID>()
    @Environment(\.editMode) private var editMode
    
    var layout: CollectionViewLayout
    @Binding var selection: Set<ID>
    var content: () -> Content
    
    var action: ((ID) -> Void)?
    var reorder: ((ID, Int) -> Void)?
    var contextMenu: (Set<ID>) -> Menu
    
    public init(
        _ layout: CollectionViewLayout,
        selection: Binding<Set<ID>>,
        @ViewBuilder content: @escaping () -> Content,
        action: ((ID) -> Void)? = nil,
        reorder: ((ID, Int) -> Void)? = nil,
        contextMenu: @escaping (Set<ID>) -> Menu
    ) {
        self.layout = layout
        self._selection = selection
        self.content = content
        self.action = action
        self.reorder = reorder
        self.contextMenu = contextMenu
    }
}

extension CollectionView: View {
    public var body: some View {
        Group {
            switch layout {
            case .list:
                List(selection: $selection, content: content)
                    .contextMenu(forSelectionType: ID.self, menu: contextMenu)
                
            case .grid(_):
                GridScrollView(content: content)
                    .task {
                        model.action = action
                        model.contextMenu = { AnyView(contextMenu($0)) }
                    }
                    .onChange(of: editMode?.wrappedValue) {
                        //reset selection on edit mode exit
                        if $0 == .inactive {
                            selection = .init()
                        }
                    }
            }
        }
            .task {
                model.reorder = reorder
            }
            .task(id: selection) { model.selection = selection }
            .task(id: model.selection) { selection = model.selection }
            .task(id: editMode?.wrappedValue.isEditing) { model.isEditing = editMode?.wrappedValue.isEditing ?? false }
            .environment(\.collectionViewLayout, layout)
            .environmentObject(model)
    }
}
