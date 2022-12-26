import SwiftUI
import API
import UI

struct CollectionGroups<T: Hashable>: View {
    @EnvironmentObject private var collections: CollectionsStore
    var tag: (Int) -> T
    
    var body: some View {
        Memorized(
            tag: tag,
            groups: collections.state.groups,
            user: collections.state.user
        )
    }
}

extension CollectionGroups where T == Int {
    init() {
        self.tag = { $0 }
    }
}

extension CollectionGroups where T == FindBy {
    init() {
        self.tag = { .init($0) }
    }
}

extension CollectionGroups {
    fileprivate struct Memorized: View {
        @EnvironmentObject private var dispatch: Dispatcher
        @EnvironmentObject private var event: CollectionEvent

        var tag: (Int) -> T
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
                .dropConsumer(to: collection)
                .swipeActions(edge: .trailing) {
                    Button {
                        event.edit(collection)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                        .tint(.accentColor)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        event.create(.parent(collection.id))
                    } label: {
                        Label("Create collection", systemImage: "plus")
                    }
                        .tint(.indigo)
                }
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
                            tag: tag,
                            content: item
                        )
                            .transition(.move(edge: .bottom))
                    }
                } header: {
                    Header(
                        group: groups[index],
                        single: groups.count == 1
                    )
                }
                    #if os(macOS)
                    .collapsible(false)
                    #endif
            }
        }
    }
}
