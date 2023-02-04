import SwiftUI
import API
import UniformTypeIdentifiers

public extension View {
    func dropConsumer(to collection: Int = -1) -> some View {
        modifier(DropConsumerModifier(collection: collection))
    }
    
    func dropConsumer(to collection: UserCollection) -> some View {
        modifier(DropConsumerModifier(collection: collection.id))
    }
    
    @ViewBuilder
    func dropConsumer(to find: FindBy) -> some View {
        if find.isSearching {
            self
        } else {
            modifier(DropConsumerModifier(collection: find.collectionId))
        }
    }
}

fileprivate struct DropConsumerModifier: ViewModifier {
    @Environment(\.drop) private var drop
    @State private var isTargeted = false

    var collection: Int
    
    func onDrop(_ items: [NSItemProvider]) -> Bool {
        guard !items.isEmpty else { return false }
        drop?(items, collection)
        return drop != nil
    }
    
    var background: Optional<Color> {
        drop != nil && isTargeted ? .accentColor.opacity(0.2): nil
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(background?.clipShape(RoundedRectangle(cornerRadius: 3)))
            .listRowBackground(background)
            .onDrop(of: [UTType.raindrop] + addTypes, isTargeted: $isTargeted, perform: onDrop)
    }
}
