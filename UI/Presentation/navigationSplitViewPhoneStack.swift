import SwiftUI

public extension View {
    func navigationSplitViewPhoneStack() -> some View {
        #if canImport(UIKit)
        modifier(NSVPS())
        #else
        self
        #endif
    }
}

fileprivate struct NSVPS: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    func body(content: Content) -> some View {
        if isPhone {
            content
                .environment(\.horizontalSizeClass, .compact)
        } else {
            content
        }
    }
}
