import SwiftUI
import API

public extension View {
    func dropRaindrop(to collectionId: Int) -> some View {
        modifier(DropRaindropToCollectionModifier(collectionId: collectionId))
    }
    
    func dropRaindrop(to collection: UserCollection) -> some View {
        modifier(DropRaindropToCollectionModifier(collectionId: collection.id))
    }
    
    func dropRaindrop(to collection: SystemCollection) -> some View {
        modifier(DropRaindropToCollectionModifier(collectionId: collection.id))
    }
}

struct DropRaindropToCollectionModifier: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var isTargeted = false
    
    var collectionId: Int
    
    func body(content: Content) -> some View {
        content
            .background {
                if isTargeted {
                    Color.accentColor
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .dropDestination(for: Raindrop.self) { items, _ in
                dispatch.sync(
                    RaindropsAction.updateMany(
                        .some(items.map { $0.id }),
                        .moveTo(collectionId)
                    )
                )
                return true
            } isTargeted: {
                isTargeted = $0
            }
    }
}
