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
        var tag: (Int) -> T
        var groups: [CGroup]
        var user: [UserCollection.ID: UserCollection]
        
        var body: some View {
            ForEach(groups.indices, id: \.self) { index in
                GroupSection(
                    group: groups[index],
                    items: user,
                    tag: tag
                )
            }
        }
    }
}
