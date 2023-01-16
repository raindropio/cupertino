import SwiftUI
import UI
import API

extension Finder {
    struct Title: ViewModifier {
        @EnvironmentObject private var c: CollectionsStore
        var find: FindBy

        func body(content: Content) -> some View {
            content.modifier(
                Memorized(find: find, title: c.state.title(find.collectionId))
            )
        }
    }
}

extension Finder.Title {
    fileprivate struct Memorized: ViewModifier {
        var find: FindBy
        var title: String
        
        var scope: String {
            if find.isSearching {
                if find.collectionId == 0 {
                    return find.search
                } else {
                    return "\(title): \(find.collectionId)"
                }
            }
            
            return title
        }
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(scope)
        }
    }
}
