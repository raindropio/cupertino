import SwiftUI
import API
import UI

struct BrowseScreen: View {
    @Binding var find: FindBy
    
    var body: some View {
        BrowseList(find: find) {
            BrowseNested(find: find)
        }
            .fab(to: find.collectionId)
            .modifier(Toolbar(find: find))
            #if os(iOS)
            .backport.toolbarRole(isPhone ? .automatic : .browser)
            #endif
    }
}
