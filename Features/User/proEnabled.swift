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
        content.modifier(Memorized(pro: user.state.me?.pro ?? false))
    }
}

extension PE {
    fileprivate struct Memorized: ViewModifier {
        var pro: Bool
        
        func body(content: Content) -> some View {
            content
                .disabled(!pro)
        }
    }
}
