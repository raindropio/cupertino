import SwiftUI
import API
import UI

struct BrowserView: View {
    var page: BrowserPage
    @State private var selection = Set<Raindrop>()
    
    func getTitle() -> String {
        switch page {
        case .collection(let collection):
            return collection.title
        case .search(let query):
            return query
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            if case .collection(let collection) = page {
                if !collection.isSystem {
                    ChildrenView(collection: collection)
                }
            }
            
            RaindropsItemsView()
        }
            .listStyle(.inset)
            .navigationTitle(getTitle())
    }
}
