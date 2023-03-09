import SwiftUI
import API
import UI

struct UserCollections<T: Hashable>: View {
    @EnvironmentObject private var collections: CollectionsStore
    var tag: (Int) -> T
    
    var body: some View {
        Groups(
            tag: tag,
            groups: collections.state.groups,
            user: collections.state.user
        )
        
        if collections.state.groups.isEmpty {
            Empty()
        }
    }
}

extension UserCollections where T == Int {
    init() {
        self.tag = { $0 }
    }
}

extension UserCollections where T == FindBy {
    init() {
        self.tag = { .init($0) }
    }
}

extension UserCollections {
    fileprivate struct Groups: View {
        var tag: (Int) -> T
        var groups: [CGroup]
        var user: [UserCollection.ID: UserCollection]
        
        var body: some View {
            ForEach(groups.indices, id: \.self) { index in
                CollectionsGroup(
                    group: groups[index],
                    items: user,
                    tag: tag
                )
            }
        }
    }
    
    fileprivate struct Empty: View {
        @Environment(\.editMode) private var editMode
        @EnvironmentObject private var sheet: CollectionSheet
        
        var body: some View {
            Section {
                if editMode?.wrappedValue != .active {
                    Button { sheet.create() } label: {
                        Label("New collection", systemImage: "plus")
                    }
                        .tint(.secondary)
                }
            }
                .listItemTint(.monochrome)
        }
    }
}
