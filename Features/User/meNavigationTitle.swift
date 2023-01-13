import SwiftUI
import API

public extension View {
    func meNavigationTitle() -> some View {
        modifier(MeNavigationTitle())
    }
}

struct MeNavigationTitle: ViewModifier {
    @EnvironmentObject private var u: UserStore

    func body(content: Content) -> some View {
        content
            .navigationTitle(u.state.me?.name ?? "")
    }
}
