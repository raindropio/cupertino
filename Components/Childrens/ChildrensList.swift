import SwiftUI
import API

struct CollectionChildrens: View {
    @EnvironmentObject private var c: CollectionsStore
    var id: UserCollection.ID
    
    var body: some View {
        CollectionsCarousel(items: c.state.childrens(of: id))
    }
}
