import SwiftUI

public extension View {
    func navigationSplitViewPhoneStack() -> some View {
        modifier(NSVPS())
    }
}

fileprivate struct NSVPS: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func body(content: Content) -> some View {
        content
            .environment(\.horizontalSizeClass, isPhone ? .compact : horizontalSizeClass)
    }
}
