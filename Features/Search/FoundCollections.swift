import SwiftUI
import API
import UI

struct FoundCollections: View {
    @EnvironmentObject private var c: CollectionsStore
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var text: String
    
    var body: some View {
        let items = c.state.find(text)
        
        Section {
            Memorized(
                items: items
            )
        } header: {
            if !items.isEmpty {
                Text("Collections")
            }
        } footer: {
            if !items.isEmpty && horizontalSizeClass == .compact {
                Text("Press enter on a keyboard to show found bookmarks")
            }
        }
    }
}

extension FoundCollections {
    fileprivate struct Memorized: View {
        var items: [UserCollection]
        
        var body: some View {
            ForEach(items) { item in
                DeepLink(.collection(.open(item.id))) {
                    UserCollectionItem(item, withLocation: true)
                }
            }
        }
    }
}
