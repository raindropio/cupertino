import SwiftUI
import API

extension View {
    func collectionsAnimation() -> some View {
        modifier(_Animation())
    }
}

fileprivate struct _Animation: ViewModifier {
    @EnvironmentObject private var collections: CollectionsStore
    
    func body(content: Content) -> some View {
        content
            .animation(.default, value: collections.state.animation)
    }
}
