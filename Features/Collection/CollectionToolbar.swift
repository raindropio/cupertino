import SwiftUI
import API

extension View {
    func collectionToolbar(for id: Int) -> some View {
        modifier(CollectionToolbar(id: id))
    }
}

struct CollectionToolbar: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @EnvironmentObject private var c: CollectionsStore
    
    var id: Int
    
    func body(content: Content) -> some View {
        if let collection: any CollectionType = c.state.user[id] ?? c.state.system[id] {
            content
                .modifier(Memorized(collection: collection))
        } else {
            content
        }
    }
}

extension CollectionToolbar {
    struct Memorized: ViewModifier {
        @Environment(\.horizontalSizeClass) private var sizeClass
        var collection: any CollectionType
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(collection.title)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            if let user = collection as? UserCollection {
                                UserCollectionMenu(collection: user)
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
