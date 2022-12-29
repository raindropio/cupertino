import SwiftUI

public extension View {
    @inlinable func task<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .userInitiated,
        debounce: Double,
        @_inheritActorContext _ action: @escaping @Sendable () async -> Void
    ) -> some View {
        task(id: id, priority: priority) {
            do {
                if debounce > 0 {
                    try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * debounce))
                }
                await action()
            } catch {}
        }
    }
    
    /// Debounce task, only happen if id value is non empty
    @inlinable func task<ID: Equatable>(
        id: ID,
        priority: TaskPriority = .userInitiated,
        debounce: Double,
        @_inheritActorContext _ action: @escaping @Sendable () async -> Void
    ) -> some View where ID: Collection {
        task(id: id, priority: priority) {
            do {
                if debounce > 0, !id.isEmpty {
                    try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * debounce))
                }
                await action()
            } catch {}
        }
    }
}
