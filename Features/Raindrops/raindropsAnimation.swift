import SwiftUI
import API

extension View {
    func raindropsAnimation() -> some View {
        modifier(RaindropsAnimation())
    }
}

fileprivate struct RaindropsAnimation: ViewModifier {
    @EnvironmentObject private var r: RaindropsStore
    
    func body(content: Content) -> some View {
        content
            .animation(.default, value: r.state.animation)
    }
}
