import SwiftUI

public extension View {
    /// Run action when screen first appear and when app become active (go from background, device unlock, etc)
    func reload(
        priority: TaskPriority = .background,
        @_inheritActorContext _ action: @Sendable @escaping () async -> Void
    ) -> some View {
        task(priority: priority, action)
            .modifier(BecomeActive(priority: priority, action: action))
    }
    
    /// Run action when screen first appear, ID change or when app become active (go from background, device unlock, etc)
    func reload<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .background,
        @_inheritActorContext _ action: @Sendable @escaping () async -> Void
    ) -> some View {
        task(id: id, priority: priority, action)
            .modifier(BecomeActive(priority: priority, action: action))
    }
    
    func reload<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .background,
        debounce: Double,
        @_inheritActorContext _ action: @Sendable @escaping () async -> Void
    ) -> some View {
        task(id: id, priority: priority, debounce: debounce, action)
            .modifier(BecomeActive(priority: priority, action: action))
    }
    
    func reload<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .background,
        debounce: Double,
        @_inheritActorContext _ action: @Sendable @escaping () async -> Void
    ) -> some View where ID: Collection {
        task(id: id, priority: priority, debounce: debounce, action)
            .modifier(BecomeActive(priority: priority, action: action))
    }
}

fileprivate struct BecomeActive: ViewModifier {
    let priority: TaskPriority
    let action: @Sendable () async -> Void
    
    func becomeActive(_ output: NotificationCenter.Publisher.Output) {
        Task(priority: priority, operation: action)
    }
    
    func body(content: Content) -> some View {
        content
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
