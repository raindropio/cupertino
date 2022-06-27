import SwiftUI
import API

struct SidebarMenu: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contextMenu(forSelectionType: SidebarSelection.self) {
                let (collections, _, _) = groupped($0)
                
                if !collections.isEmpty {
                    TreeMenu(selection: collections)
                }
            }
    }
    
    func groupped(_ selection: Set<SidebarSelection>) -> (Set<Collection>, Set<Filter>, Set<Tag>) {
        var collections = Set<Collection>()
        var filters = Set<Filter>()
        var tags = Set<Tag>()
        
        selection.forEach {
            switch($0) {
            case .collection(let collection): collections.insert(collection)
            case .filter(let filter): filters.insert(filter)
            case .tag(let tag): tags.insert(tag)
            }
        }
        
        return (collections, filters, tags)
    }
}
