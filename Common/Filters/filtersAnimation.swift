import SwiftUI
import API

extension View {
    func filtersAnimation() -> some View {
        modifier(FiltersAnimation())
    }
}

fileprivate struct FiltersAnimation: ViewModifier {
    @EnvironmentObject private var f: FiltersStore
    
    func body(content: Content) -> some View {
        content
            .animation(.default, value: f.state.animation)
    }
}
