import SwiftUI
import API
import UI

struct UserCollections<T: Hashable>: View {
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
    fileprivate struct Memorized: View {
        @Environment(\.editMode) private var editMode
        @EnvironmentObject private var event: CollectionsEvent
        
        var tag: (Int) -> T
        var groups: [CGroup]
        var user: [UserCollection.ID: UserCollection]
        
        var body: some View {
            if user.isEmpty {
                if editMode?.wrappedValue != .active {
                    EmptyState(
                        message: "Whether you’re planning a presentation, preparing for an event or creating a website, create a collection so all the important items are saved in one central place."
                    ) {
                        Image(systemName: "square.grid.3x1.folder.badge.plus")
                    } actions: {
                        Button("Create collection") {
                            event.create()
                        }
                    }
                }
            } else {
                ForEach(groups.indices, id: \.self) { index in
                    CollectionsGroup(
                        group: groups[index],
                        items: user,
                        tag: tag
                    )
                }
            }
        }
    }
}
