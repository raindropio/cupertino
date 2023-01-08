import SwiftUI

public actor Dispatcher: ObservableObject {
    @MainActor var store: Store?
    
    //async version
    public func callAsFunction(_ action: ReduxAction) async throws {
        try await store?.dispatch(action)
    }
    
    //run multiple in parallel
    public func callAsFunction(_ actions: [ReduxAction]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { [self] group in
            for action in actions {
                group.addTask { try await self.store?.dispatch(action) }
            }
            for try await _ in group {}
        }
    }
    
    public func callAsFunction(_ actions: ReduxAction...) async throws {
        try await callAsFunction(actions)
    }
    
    //sync version
    @MainActor
    public func sync(_ action: ReduxAction) {
        Task(priority: .userInitiated) {
            try? await store?.dispatch(action)
        }
    }
}
