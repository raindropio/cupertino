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
                .animation(.default, value: refine.isSearching || isActive)
                .animation(.default, value: f.state.animation)
                .animation(.default, value: c.state.animation)
                .animation(.default, value: rc.state.animation)
        }
    }
}
