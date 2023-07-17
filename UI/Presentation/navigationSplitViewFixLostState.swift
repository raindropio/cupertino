import SwiftUI

public extension View {
    /// on iPad when app change it size or goes to background entire NavigationSplitView is recreated
    /// This modifier fixes this issue, but downside is `horizontalSizeClass` will be always `regular`
    func navigationSplitViewFixLostState() -> some View {
        #if canImport(UIKit)
        modifier(NSVPR())
        #else
        self
        #endif
    }
}

fileprivate struct NSVPR: ViewModifier {
    func body(content: Content) -> some View {
        if isPhone {
            content
        } else {
            content
                .environment(\.horizontalSizeClass, .regular)
        }
    }
}
