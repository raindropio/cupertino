import SwiftUI
import API

extension Spotlight {
    struct Animations: ViewModifier {
        @EnvironmentObject private var f: FiltersStore
        @EnvironmentObject private var r: RecentStore
        @AppStorage("recent-expanded") private var recentExpanded = true

        var find: FindBy
        
        func body(content: Content) -> some View {
            content
                .animation(.default, value: f.state.animation)
                .animation(.default, value: r.state.animation)
                .animation(.default, value: recentExpanded)
        }
    }
}
