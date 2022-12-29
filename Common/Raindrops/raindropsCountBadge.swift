import SwiftUI
import API
import UI
import Backport

extension View {
    func raindropsCountBadge(_ search: String) -> some View {
        modifier(RaindropsCountBadge(find: .init(search)))
    }
}

fileprivate struct RaindropsCountBadge: ViewModifier {
    @EnvironmentObject private var r: RaindropsStore
    @EnvironmentObject private var dispatch: Dispatcher

    var find: FindBy
    
    var count: Int {
        r.state.total(find)
    }
    
    func body(content: Content) -> some View {
        content
            .badge(Text(count > 0 ? "\(count) bookmarks" : ""))
            .task(id: find, debounce: 0.5) {
                try? await dispatch(RaindropsAction.load(find))
            }
    }
}
