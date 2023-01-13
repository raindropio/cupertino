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
            .foregroundColor(.white)
            .padding(6)
            .background(.tint, in: Circle())
    }
}
