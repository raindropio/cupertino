import SwiftUI
import API

extension CollectionsList {
    struct Animation: ViewModifier {
        @EnvironmentObject private var collections: CollectionsStore
        
        func body(content: Content) -> some View {
            content
                .animation(.default, value: collections.state.expandedCount)
        }
    }
}
