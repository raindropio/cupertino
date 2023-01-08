import SwiftUI
import API
import Common
import UI

extension BrowseScreen {
    struct Toolbar: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass
        @EnvironmentObject private var c: CollectionsStore
        
        var find: FindBy
        
        func body(content: Content) -> some View {
            if let collection: any CollectionType = c.state.user[find.collectionId] ?? c.state.system[find.collectionId] {
                content
                    .modifier(Memorized(find: find, collection: collection))
            } else {
                content
            }
        }
    }
}

extension BrowseScreen.Toolbar {
    struct Memorized: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass
        @Environment(\.editMode) private var editMode
        @EnvironmentObject private var app: AppRouter
        
        var find: FindBy
        var collection: any CollectionType
        
        var title: String {
            if find.isSearching {
                return find.search
            }
            return collection.title
        }
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        if sizeClass == .compact {
                            Button {
                                app.spotlight = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                        }
                    }
                    
                    ToolbarItem {
                        if editMode?.wrappedValue != .active {
                            Menu {
                                EditButton("Select")
                                CollectionsMenu(collection.id)
                            } label: {
                                Label(collection.title, systemImage: "ellipsis.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                        }
                    }
                }
        }
    }
}
