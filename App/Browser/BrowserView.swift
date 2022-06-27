import SwiftUI
import API
import UI

struct BrowserView: View {
    var page: SidebarSelection
    @State private var selection = Set<Raindrop>()
    
    func getTitle() -> String {
        switch page {
        case .collection(let collection):
            return collection.title
        case .filter(let filter):
            return filter.title
        case .tag(let tag):
            return tag.title
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            if case .collection(let collection) = page {
                if !collection.isSystem {
                    ChildrenView(collection: collection)
                }
            }
            
            RaindropItems()
        }
            .listStyle(.inset)
            .navigationTitle(getTitle())
    }
}
