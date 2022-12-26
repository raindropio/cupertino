import SwiftUI
import API

struct SystemCollections<T: Hashable>: View {
    var ids: [SystemCollection.ID]
    var tag: (Int) -> T
    
    var body: some View {
        ForEach(ids, id: \.self) {
            SystemCollectionRow(id: $0)
                .dropConsumer(to: $0)
                .backport.tag(tag($0))
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
