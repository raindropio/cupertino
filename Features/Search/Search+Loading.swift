import SwiftUI
import API

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
                .task(id: refine, priority: .background, reload)
                .task(id: isActive, priority: .background, reload)
        }
    }
}
