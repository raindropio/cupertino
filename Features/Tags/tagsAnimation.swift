import SwiftUI
import API

extension View {
    func tagAnimations() -> some View {
        modifier(TagAnimations())
    }
}

fileprivate struct TagAnimations: ViewModifier {
    @EnvironmentObject private var f: FiltersStore
    @AppStorage("tags-expanded") private var tagsExpanded = true
    
    func body(content: Content) -> some View {
        content
            .animation(.default, value: f.state.animation)
            .animation(.default, value: tagsExpanded)
    }
}
