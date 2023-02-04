import SwiftUI

public extension View {
    func listContextMenuBehaviour<I: Hashable, M: View>(
        forSelectionType itemType: I.Type = I.self,
        @ViewBuilder menu: @escaping (Set<I>) -> M,
        primaryAction: ((Set<I>) -> Void)? = nil
    ) -> some View {
        modifier(ContextMenuBehaviour(menu: menu, primaryAction: primaryAction))
    }
}

fileprivate struct ContextMenuBehaviour<I: Hashable, M: View>: ViewModifier {
    @StateObject private var service = ListBehaviourService<I>()
    
    var menu: (Set<I>) -> M
    var primaryAction: ((Set<I>) -> Void)? = nil
    
    func body(content: Content) -> some View {
        content
            .environmentObject(service)
            .task(priority: .background) {
                service.primaryAction = primaryAction
                service.menu = { AnyView(menu($0)) }
            }
    }
}
