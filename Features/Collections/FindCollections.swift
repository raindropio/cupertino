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
        
        CreateCollection(search: search)
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

fileprivate struct CreateCollection: View {
    @EnvironmentObject private var dispatch: Dispatcher
    var search: String

    var body: some View {
        Section {
            ActionButton {
                var collection = UserCollection.new()
                collection.title = search
                try await dispatch(CollectionsAction.create(collection))
            } label: {
                Label("Create \(search)", systemImage: "folder.badge.plus")
            }
        }
    }
}
