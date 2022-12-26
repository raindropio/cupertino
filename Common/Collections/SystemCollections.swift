import SwiftUI
import API

struct SystemCollections<T: Hashable>: View {
    @EnvironmentObject private var c: CollectionsStore
    
    var ids: [SystemCollection.ID]
    var tag: (Int) -> T
    
    var body: some View {
        Memorized(
            collections: ids.compactMap { c.state.system[$0] },
            tag: tag
        )
    }
}

extension SystemCollections {
    struct Memorized: View {
        var collections: [SystemCollection]
        var tag: (Int) -> T
        
        var body: some View {
            ForEach(collections) {
                SystemCollectionRow($0)
                    .dropConsumer(to: $0.id)
                    .backport.tag(tag($0.id))
            }
        }
    }
}

extension SystemCollections where T == Int {
    init(_ ids: SystemCollection.ID...) {
        self.ids = ids
        self.tag = { $0 }
    }
}

extension SystemCollections where T == FindBy {
    init(_ ids: SystemCollection.ID...) {
        self.ids = ids
        self.tag = { .init($0) }
    }
}
