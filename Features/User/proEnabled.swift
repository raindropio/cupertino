import SwiftUI
import API

public extension View {
    func proEnabled() -> some View {
        modifier(PE())
    }
}

fileprivate struct PE: ViewModifier {
    @EnvironmentObject private var user: UserStore

    func body(content: Content) -> some View {
        content
            .disabled(user.state.me?.pro != true)
    }
}
