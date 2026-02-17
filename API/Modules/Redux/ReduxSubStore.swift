import SwiftUI

actor ReduxEngine<R: Reducer> {
    let reducer = R()
    private(set) var state: R.S = R.S()

    func reduce(_ action: ReduxAction) throws -> (R.S, ReduxAction?, R, Bool) {
        let oldState = state
        let next = try reducer.reduce(state: &state, action: action)
        return (state, next, reducer, oldState != state)
    }

    func current() -> (R.S, R) {
        (state, reducer)
    }
}

@MainActor
public class ReduxSubStore<R: Reducer>: ObservableObject {
    let engine = ReduxEngine<R>()
    @Published public private(set) var state = R.S()

    nonisolated func process(_ some: Any) async throws -> [ReduxAction] {
        var nextActions: [ReduxAction] = []

        if let action = some as? ReduxAction {
            let (newState, nextFromReduce, reducer, stateChanged) = try await engine.reduce(action)

            if stateChanged {
                await MainActor.run { self.state = newState }
            }

            if let next = nextFromReduce {
                nextActions.append(next)
            }

            if let nextFromMiddleware = try await reducer.middleware(state: newState, action: action) {
                nextActions.append(nextFromMiddleware)
            }
        }
        else if let error = some as? Error {
            let (state, reducer) = await engine.current()
            if let nextFromMiddleware = try await reducer.middleware(state: state, error: error) {
                nextActions.append(nextFromMiddleware)
            }
        }

        return nextActions
    }
}