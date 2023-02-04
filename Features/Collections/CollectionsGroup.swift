import SwiftUI
import API
import UI

struct CollectionsGroup<T: Hashable>: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @EnvironmentObject private var event: CollectionsEvent

    var group: CGroup
    var items: [UserCollection.ID: UserCollection]
    var tag: (Int) -> T
    
    func add() {
        event.create(.group(group))
    }

    func toggle() {
        dispatch.sync(CollectionsAction.toggleGroup(group))
    }
    
    func toggle(_ id: UserCollection.ID) {
        dispatch.sync(CollectionsAction.toggle(id))
    }
    
    func reorder(_ ids: [UserCollection.ID], parent: UserCollection.ID?, order: Int) {
        if let id = ids.first {
            dispatch.sync(CollectionsAction.reorder(id, parent: parent, order: order))
        }
    }
    
    var body: some View {
        DisclosureSection(group.title, isExpanded: !group.hidden, toggle: toggle) {
            LazyTree(
                root: group.collections,
                items: items,
                parent: \.parent,
                expanded: \.expanded,
                sort: \.sort,
                toggle: toggle,
                reorder: reorder,
                tag: tag,
                content: UserCollectionItem.init
            )
                .transition(.move(edge: .bottom))
        } actions: {
            Button(action: add) {
                Image(systemName: "plus")
            }
                .fontWeight(.semibold)
        }
    }
}
