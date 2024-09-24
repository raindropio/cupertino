import SwiftUI
import Combine

public class ReduxSubStore<R: Reducer>: ObservableObject {
    private var reducer = R()
    private let queue = DispatchQueue(label: "ReduxSubStore.\(R.self)")
    @Published public private(set) var state = R.S()

    func reduce(_ some: Any) throws -> ReduxAction? {
        return try queue.sync {
            if let action = some as? ReduxAction {
                var newState = state
                let result = try reducer.reduce(state: &newState, action: action)
                if newState != state {
                    DispatchQueue.main.async {
                        self.state = newState
                    }
                }
                return result
            }
            return nil
        }
    }

    func middleware(_ some: Any) async throws -> ReduxAction? {
        #if DEBUG
        let start = Date()
        defer {
            let took = Date().timeIntervalSince(start)
            if took > 1 {
                print("Slow action (\(String(format: "%.2f", took))s):", R.self, some)
            }
        }
        #endif

        let currentState = try await withCheckedThrowingContinuation { continuation in
            queue.async {
                continuation.resume(returning: self.state)
            }
        }

        if let action = some as? ReduxAction {
            return try await reducer.middleware(state: currentState, action: action)
        } else if let error = some as? Error {
            return try await reducer.middleware(state: currentState, error: error)
        }
        return nil
    }
}
