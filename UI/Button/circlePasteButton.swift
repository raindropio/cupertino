import SwiftUI

public extension View {
    func circlePasteButton() -> some View {
        modifier(CPB())
    }
}

fileprivate struct CPB: ViewModifier {
    func body(content: Content) -> some View {
        content
            .labelStyle(.iconOnly)
            .buttonBorderShape(.capsule)
            .background(
                Rectangle().fill(.tint)
                    .overlay(.black.opacity(0.03))
                    .frame(width: 52, height: 52)
                    .fixedSize()
                    .clipShape(Circle())
                    .shadow(radius: 0, y: 0.5)
                    .shadow(radius: 30, y: 5)
                    .allowsHitTesting(false)
            )
    }
}
