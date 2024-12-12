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
                .safeAnimation(.default, value: refine.isSearching || isActive)
                .modifier(Memorized(f: f.state.animation, c: c.state.animation, rc: rc.state.animation))
        }
    }
}

extension Search.Animations {
    fileprivate struct Memorized: ViewModifier {
        var f: UUID
        var c: UUID
        var rc: UUID
        
        func body(content: Content) -> some View {
            content
                .safeAnimation(.default, value: f)
                .safeAnimation(.default, value: c)
                .safeAnimation(.default, value: rc)
        }
    }
}
