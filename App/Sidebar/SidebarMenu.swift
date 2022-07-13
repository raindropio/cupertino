import SwiftUI
import API

struct SidebarMenu: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contextMenu(forSelectionType: Route.self) {
                let (collections, _, _) = groupped($0)
                
                if !collections.isEmpty {
                    TreeMenu(selection: collections)
                }
            }
    }
    
    func groupped(_ selection: Set<Route>) -> (Set<Collection>, Set<Filter>, Set<Tag>) {
        var collections = Set<Collection>()
        var filters = Set<Filter>()
        var tags = Set<Tag>()
        
        selection.forEach {
            switch($0) {
            case .browse(let collection, _): collections.insert(collection)
            default: break
            }
        }
        
        return (collections, filters, tags)
    }
}
