import SwiftUI

struct DebouncingTaskViewModifier<ID: Equatable>: ViewModifier {
    let id: ID
    let priority: TaskPriority
    let nanoseconds: UInt64
    let task: @Sendable () async -> Void
    
    init(
        id: ID,
        priority: TaskPriority = .userInitiated,
        ms: UInt64 = 0,
        task: @Sendable @escaping () async -> Void
    ) {
        self.id = id
        self.priority = priority
        self.nanoseconds = 1_000_000 * ms
        self.task = task
    }
    
    func body(content: Content) -> some View {
        content.task(id: id, priority: priority) {
            do {
                try await Task.sleep(nanoseconds: nanoseconds)
                await task()
            } catch {
                // Ignore cancellation
            }
        }
    }
}

public extension View {
    func task<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .userInitiated,
        ms: UInt64 = 0,
        task: @Sendable @escaping () async -> Void
    ) -> some View {
        modifier(
            DebouncingTaskViewModifier(
                id: id,
                priority: priority,
                ms: ms,
                task: task
            )
        )
    }
}

