import SwiftUI
import API

extension Spotlight {
    struct Animations: ViewModifier {
        @EnvironmentObject private var f: FiltersStore
        @EnvironmentObject private var c: CollectionsStore
        @EnvironmentObject private var rc: RecentStore
        @EnvironmentObject private var rn: RaindropsStore
        @AppStorage("recent-expanded") private var recentExpanded = true

        var find: FindBy
        
        func body(content: Content) -> some View {
            content
                .animation(
                    .spring(),
                    value: [find.isSearching, recentExpanded]
                )
                .animation(
                    .spring(),
                    value:  f.state.simple(find).count
                            + f.state.tags(find).count
                            + c.state.find(find).count
                            + rc.state.search(find).count
                )
                .animation(
                    .spring(),
                    value: rn.state.status(find)
                )
        }
    }
}
