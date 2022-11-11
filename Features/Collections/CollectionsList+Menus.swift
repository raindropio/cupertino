import SwiftUI
import API

extension CollectionsList {
    struct Menus: ViewModifier {
        @EnvironmentObject private var collections: CollectionsStore

        func body(content: Content) -> some View {
            content
                .contextMenu(forSelectionType: Int.self) { selection in
                    if let id = selection.first,
                        let collection = collections.state.user[id] {
                        UserCollectionMenu(collection: collection)
                    }
                }
        }
    }
}
