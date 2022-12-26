import SwiftUI
import API

extension View {
    func collectionsAnimation() -> some View {
        modifier(CollectionsAnimation())
    }
}

fileprivate struct CollectionsAnimation: ViewModifier {
    @EnvironmentObject private var collections: CollectionsStore
    
    func body(content: Content) -> some View {
        content
            .animation(.default, value: collections.state.animation)
    }
}
