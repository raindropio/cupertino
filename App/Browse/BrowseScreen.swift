import SwiftUI
import API
import UI

struct BrowseScreen: View {
    @Binding var find: FindBy
    
    var body: some View {
        BrowseList(find: find) {
            BrowseNested(find: find)
        }
            .addFab(to: find.collectionId)
            .globalSearch(find: $find)
            .modifier(Toolbar(find: find))
            #if os(iOS)
            .toolbarRole(isPhone ? .automatic : .browser)
            #endif
    }
}
