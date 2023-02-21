import SwiftUI
import API
import UI

extension Search {
    struct Loading: ViewModifier {
        @EnvironmentObject private var dispatch: Dispatcher

        @Binding var refine: FindBy
        var isActive: Bool
        
        @Sendable
        func reload() async {
            guard isActive else { return }
            try? await dispatch([
                FiltersAction.reload(refine),
                RecentAction.reload(refine)
            ])
        }

        func body(content: Content) -> some View {
            content
                .task(id: refine, priority: .background, debounce: 0.3, reload)
                .task(id: isActive, priority: .background, debounce: 0.3, reload)
        }
    }
}
