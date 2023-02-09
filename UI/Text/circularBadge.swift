import SwiftUI

public extension View {
    func circularBadge() -> some View {
        modifier(CircularBadge())
    }
}

struct CircularBadge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote.monospacedDigit().weight(.semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 7)
            .background(.tint, in: Capsule())
    }
}
