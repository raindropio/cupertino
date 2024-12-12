import SwiftUI
import API

extension View {
    func tagAnimations() -> some View {
        modifier(TagAnimations())
    }
}

fileprivate struct TagAnimations: ViewModifier {
    @EnvironmentObject private var f: FiltersStore
    
    func body(content: Content) -> some View {
        content.modifier(Memorized(animation: f.state.animation))
    }
}

extension TagAnimations {
    struct Memorized: ViewModifier {
        var animation: UUID
        
        func body(content: Content) -> some View {
            content
                .safeAnimation(.default, value: animation)
        }
    }
}
