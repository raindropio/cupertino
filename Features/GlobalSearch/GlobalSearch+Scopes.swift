import SwiftUI
import API

extension GlobalSearch {
    struct Scopes: ViewModifier {
        @Binding var find: FindBy
        @State private var back: UserCollection.ID?

        func body(content: Content) -> some View {
            content
                .task(id: find.collectionId) {
                    if find.collectionId != 0 {
                        back = find.collectionId
                    }
                }
                .searchScopes($find.collectionId) {
                    if let back {
                        Text("Everywhere").tag(0)
                        CollectionTitle(id: back).tag(back)
                    }
                }
        }
    }
}

extension GlobalSearch.Scopes {
    fileprivate struct CollectionTitle: View {
        @EnvironmentObject private var collections: CollectionsStore
        var id: UserCollection.ID
        
        var body: some View {
            Text(collections.state.title(id))
        }
    }
}
