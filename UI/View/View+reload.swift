import SwiftUI

public extension View {
    /// Run action when screen first appear and when app become active (go from background, device unlock, etc)
    func reload(
        priority: TaskPriority = .background,
        action: @Sendable @escaping () async -> Void
    ) -> some View {
        modifier(
            ReloadTaskViewModifier(
                id: 0,
                priority: priority,
                action: action
            )
        )
    }
    
    /// Run action when screen first appear, ID change or when app become active (go from background, device unlock, etc)
    func reload<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .background,
        action: @Sendable @escaping () async -> Void
    ) -> some View {
        modifier(
            ReloadTaskViewModifier(
                id: id,
                priority: priority,
                action: action
            )
        )
    }
}

fileprivate struct ReloadTaskViewModifier<ID: Equatable>: ViewModifier {
    let id: ID
    let priority: TaskPriority
    let action: @Sendable () async -> Void
    
    func becomeActive(_ output: NotificationCenter.Publisher.Output) {
        Task(priority: priority, operation: action)
    }
    
    func body(content: Content) -> some View {
        content
            .task(id: id, priority: priority, action)
            #if os(macOS)
            .onReceive(
                NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification),
                perform: becomeActive
            )
            #else
            .onReceive(
                NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
                perform: becomeActive
            )
            #endif
    }
}
