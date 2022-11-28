import SwiftUI

protocol ReduxStore: Actor, ObservableObject {
    func dispatch(_ some: Any) async throws
    func dispatch(_ some: Any, store: KeyPath<Self, ReduxSubStore<some Reducer>>) async throws
}

extension ReduxStore {
    func dispatch(_ some: Any, store: KeyPath<Self, ReduxSubStore<some Reducer>>) async throws {
        let next = try await self[keyPath: store].reduce(some)
        if let next {
            try await dispatch(next)
        }
    }
}
