import SwiftUI

public extension View {
    /// When app goes to background on iPad NavigationSplitView resets sidebar state. This modifier fixes this bug
    func navigationSplitViewFixStateReset() -> some View {
        #if canImport(UIKit)
        modifier(FixSceneBackground())
        #else
        self
        #endif
    }
}

fileprivate struct FixSceneBackground: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    func body(content: Content) -> some View {
        if isPhone {
            content
        } else {
            content
                .opacity(scenePhase == .background ? 0 : 1)
                .environment(\.horizontalSizeClass, scenePhase == .background ? .compact : horizontalSizeClass)
                .environment(\.verticalSizeClass, scenePhase == .background ? .compact : verticalSizeClass)
        }
    }
}
