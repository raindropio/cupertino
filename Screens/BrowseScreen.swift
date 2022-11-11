import SwiftUI
import API
import UI

struct BrowseScreen: View {
    @Binding var find: FindBy
    
    var body: some View {
        RaindropsList(find: find) {
            Group {
                if !find.isSearching {
                    CollectionChildrens(id: find.collectionId)
                }
            }
        }
            .globalSearch(find: $find)
            .collectionToolbar(for: find.collectionId)
            #if os(iOS)
            .toolbarRole(isPhone ? .automatic : .browser)
            #endif
    }
}
