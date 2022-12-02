import SwiftUI
import API
import UI

extension CollectionsList {
    struct Menus: ViewModifier {
        @EnvironmentObject private var collections: CollectionsStore

        func body(content: Content) -> some View {
            content
                .backport.contextMenu(forSelectionType: Int.self) { selection in
                    if let id = selection.first,
                        let collection = collections.state.user[id] {
                        UserCollectionMenu(collection)
                    }
                }
        }
    }
}
