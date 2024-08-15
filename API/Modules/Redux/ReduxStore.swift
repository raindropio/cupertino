import Foundation

protocol ReduxStore: Actor, ObservableObject {
    func dispatch(_ some: Any) async throws
    func dispatch(_ some: Any, store: KeyPath<Self, ReduxSubStore<some Reducer>>) async throws
}

extension ReduxStore {
    func dispatch(_ some: Any, store: KeyPath<Self, ReduxSubStore<some Reducer>>) async throws {
        if let next = try await self[keyPath: store].reduce(some) {
            try await dispatch(next)
        }
        //TODO: can be inaccessible if reducer fail
        if let next = try await self[keyPath: store].middleware(some) {
            try await dispatch(next)
        }
    }
}
