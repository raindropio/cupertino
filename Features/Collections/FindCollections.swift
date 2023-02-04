import SwiftUI
import API
import UI

struct FindCollections<T: Hashable>: View {
    @EnvironmentObject private var c: CollectionsStore
    var search: String
    var tag: (Int) -> T

    var body: some View {
        Memorized(
            user: c.state.find(search),
            tag: tag
        )
    }
}

extension FindCollections {
    fileprivate struct Memorized: View {
        var user: [UserCollection]
        var tag: (Int) -> T

        var body: some View {
            Section {
                if !user.isEmpty {
                    ForEach(user) { item in
                        UserCollectionItem(item, withLocation: true)
                            .tag(tag(item.id))
                    }
                }
            } header: {
                if !user.isEmpty {
                    Text("Found \(user.count) collections")
                }
            }
        }
    }
}

extension FindCollections where T == Int {
    init(_ search: String) {
        self.search = search
        self.tag = { $0 }
    }
}

extension FindCollections where T == FindBy {
    init(_ search: String) {
        self.search = search
        self.tag = { .init($0) }
    }
}
