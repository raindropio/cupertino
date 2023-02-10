import SwiftUI
import API

extension Search {
    struct Animations: ViewModifier {
        @EnvironmentObject private var f: FiltersStore
        @EnvironmentObject private var c: CollectionsStore
        @EnvironmentObject private var rc: RecentStore

        @Binding var refine: FindBy
        var isActive: Bool
        
        func body(content: Content) -> some View {
            content
                .animation(
                    .spring(),
                    value: refine.isSearching || isActive
                )
                .animation(
                    .spring(),
                    value:  f.state.simple(refine).count
                            + f.state.tags(refine).count
                            + f.state.completion(refine).count
                            + c.state.find(refine).count
                            + rc.state.search(refine).count
                )
        }
    }
}
