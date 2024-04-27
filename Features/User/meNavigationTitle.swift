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
        content.modifier(Memorized(name: u.state.me?.name))
    }
}

extension MeNavigationTitle {
    fileprivate struct Memorized: ViewModifier {
        var name: String?
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(name ?? "")
        }
    }
}
