import SwiftUI
import API

extension Spotlight {
    struct Animations: ViewModifier {
        @EnvironmentObject private var f: FiltersStore
        @EnvironmentObject private var c: CollectionsStore
        @EnvironmentObject private var rc: RecentStore
        @EnvironmentObject private var rn: RaindropsStore

        var find: FindBy
        
        func body(content: Content) -> some View {
            content
                .animation(
                    .spring(),
                    value: find.isSearching
                )
                .animation(
                    .spring(),
                    value:  f.state.simple(find).count
                            + f.state.tags(find).count
                            + f.state.completion(find).count
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
