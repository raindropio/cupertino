import Foundation

protocol ReduxStore: ObservableObject {
    func dispatch(_ some: Any) async throws
    nonisolated func process(_ some: Any, store: ReduxSubStore<some Reducer>) async throws
}

extension ReduxStore {
    nonisolated func process(_ some: Any, store: ReduxSubStore<some Reducer>) async throws {
        let nextActions = try await store.process(some)

        // Dispatch chained actions
        for action in nextActions {
            try await dispatch(action)
        }
    }
}
