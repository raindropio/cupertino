import SwiftUI
import API
import UniformTypeIdentifiers

public extension View {
    func dropRaindrop(to collectionId: Int) -> some View {
        modifier(DropRaindropToCollectionModifier(collectionId: collectionId))
    }
    
    func dropRaindrop(to collection: UserCollection) -> some View {
        dropRaindrop(to: collection.id)
    }
    
    func dropRaindrop(to collection: SystemCollection) -> some View {
        dropRaindrop(to: collection.id)
    }
}

struct DropRaindropToCollectionModifier: ViewModifier {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var isTargeted = false
    
    var collectionId: Int
    
    func onDrop(_ items: [NSItemProvider]) -> Bool {
        Task {
            let items = items
            try? await dispatch(
                RaindropsAction.updateMany(
                    .some(await Raindrop.getData(items)),
                    .moveTo(collectionId)
                )
            )
        }
        return true
    }
    
    func body(content: Content) -> some View {
        content
            .background {
                if isTargeted {
                    Color.accentColor
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .onDrop(of: [UTType.raindrop], isTargeted: $isTargeted, perform: onDrop)
    }
}
