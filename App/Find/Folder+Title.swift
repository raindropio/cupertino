import SwiftUI
import UI
import API

extension Folder {
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

extension Folder.Title {
    fileprivate struct Memorized: ViewModifier {
        @Environment(\.isSearching) private var isSearching
        
        var find: FindBy
        var title: String
        
        var scope: String {
            if find.isSearching {
                if isSearching {
                    return "Search"
                } else if find.collectionId == 0 {
                    return find.search
                } else {
                    return "\(title): \(find.search)"
                }
            }
            
            return title
        }
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(scope)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
