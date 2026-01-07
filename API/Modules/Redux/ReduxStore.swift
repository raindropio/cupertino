import Foundation

protocol ReduxStore: ObservableObject {
    func dispatch(_ some: Any) async throws
    func process(_ some: Any, store: KeyPath<Self, ReduxSubStore<some Reducer>>) async throws
}

extension ReduxStore {
    func process(_ some: Any, store: KeyPath<Self, ReduxSubStore<some Reducer>>) async throws {
        let nextActions = try await self[keyPath: store].process(some)

        // Dispatch chained actions
        for action in nextActions {
            try await dispatch(action)
        }
    }
}
