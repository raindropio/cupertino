import SwiftUI

public extension View {
    /// Run action when screen first appear and when app become active (go from background, device unlock, etc)
    func reload(
        priority: TaskPriority = .background,
        @_inheritActorContext _ action: @Sendable @escaping () async -> Void
    ) -> some View {
        modifier(Reload<Int>(priority: priority, action: action))
    }
    
    /// Run action when screen first appear, ID change or when app become active (go from background, device unlock, etc)
    func reload<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .background,
        @_inheritActorContext _ action: @Sendable @escaping () async -> Void
    ) -> some View {
        modifier(Reload(id: id, priority: priority, action: action))
    }
    
    /// Run action when screen first appear, ID change or when app become active (go from background, device unlock, etc)
    func reload<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .background,
        debounce: Double,
        @_inheritActorContext _ action: @Sendable @escaping () async -> Void
    ) -> some View {
        modifier(Reload(id: id, priority: priority, debounce: debounce, action: action))
    }
}

fileprivate struct Reload<ID: Equatable>: ViewModifier {
    var id: ID?
    var priority: TaskPriority
    var debounce: Double = 0
    var action: @Sendable () async -> Void
    
    func becomeActive(_ output: NotificationCenter.Publisher.Output) {
        Task(priority: priority, operation: action)
    }
    
    func body(content: Content) -> some View {
        Group {
            if let id {
                content
                    .task(id: id, priority: priority, debounce: debounce, action)
            } else {
                content
                    .task(priority: priority, action)
            }
        }
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
