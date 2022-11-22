import SwiftUI
import API
import UI

struct CollectionsTree: View {
    @EnvironmentObject private var collections: CollectionsStore

    var body: some View {
        Memorized(
            groups: collections.state.groups,
            user: collections.state.user
        )
    }
}

extension CollectionsTree {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var action: CollectionActionsStore

        var groups: [CGroup]
        var user: [UserCollection.ID: UserCollection]
        
        func toggle(_ id: UserCollection.ID) {
            dispatch.sync(CollectionsAction.toggle(id))
        }
        
        func reorder(_ ids: [UserCollection.ID], parent: UserCollection.ID?, order: Int) {
            if let id = ids.first {
                dispatch.sync(CollectionsAction.reorder(id, parent: parent, order: order))
            }
        }
        
        func item(_ collection: UserCollection) -> some View {
            UserCollectionRow(collection)
                .badge(collection.count)
                .dropRaindrop(to: collection)
                .swipeActions(edge: .trailing) {
                    Button {
                        action(.edit(collection))
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                        .tint(.blue)

                    Button {
                        action(.delete(collection))
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                        .tint(.red)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        action(.create(.parent(collection.id)))
                    } label: {
                        Label("Create collection", systemImage: "plus.rectangle.on.folder")
                    }
                        .tint(.indigo)
                }
                .tag(collection.id)
        }
        
        var body: some View {
            ForEach(groups.indices, id: \.self) { index in
                Section {
                    if !groups[index].hidden {
                        LazyTree(
                            root: groups[index].collections,
                            items: user,
                            parent: \.parent,
                            expanded: \.expanded,
                            sort: \.sort,
                            toggle: toggle,
                            reorder: reorder,
                            content: item
                        )
                            .transition(.move(edge: .bottom))
                    }
                } header: {
                    CollectionsGroupHeader(group: groups[index])
                }
                    #if os(macOS)
                    .collapsible(false)
                    #endif
            }
        }
    }
}
