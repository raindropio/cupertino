import SwiftUI
import API

extension View {
    func raindropsAnimation() -> some View {
        #if canImport(UIKit)
        modifier(RaindropsAnimation())
        #else
        self
        #endif
    }
}

fileprivate struct RaindropsAnimation: ViewModifier {
    @EnvironmentObject private var r: RaindropsStore
    
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut(duration: 0.3), value: r.state.animation)
    }
}
