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
                    .modifier(Memorized(collection: collection))
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
        var collection: any CollectionType
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(collection.title)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        if editMode?.wrappedValue == .inactive {
                            Menu {
                                EditButton("Select")
                                
                                if let user = collection as? UserCollection {
                                    UserCollectionMenu(user)
                                }
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
