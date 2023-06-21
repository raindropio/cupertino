import SwiftUI
import API

public extension View {
    func collectionTint(_ id: Int) -> some View {
        modifier(ById(id: id))
    }
}

fileprivate struct ById: ViewModifier {
    @EnvironmentObject private var c: CollectionsStore
    var id: Int
    
    private var color: Color? {
        if let collection = c.state.user[id] {
            return collection.color
        } else if let collection = c.state.system[id] {
            return collection.color
        }
        return nil
    }
    
    func body(content: Content) -> some View {
        content.tint(color)
    }
}
