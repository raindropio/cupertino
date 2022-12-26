import SwiftUI
import API

func CollectionsMenu(_ ids: Set<Int>) -> some View {
    _CollectionsMenu(ids: ids)
}

func CollectionsMenu(_ ids: Set<FindBy>) -> some View {
    _CollectionsMenu(ids: .init(ids.map { $0.collectionId }))
}

fileprivate struct _CollectionsMenu: View {
    @EnvironmentObject private var collections: CollectionsStore

    var ids: Set<Int>
    
    var body: some View {
        if let id = ids.first,
            let collection = collections.state.user[id] {
            UserCollectionMenu(collection)
        }
    }
}
