import SwiftUI
import Combine

public actor ReduxSubStore<R: Reducer>: ObservableObject {
    private var reducer = R()
    
    @MainActor @Published public var state: R.S
    private var working = R.S() { didSet { didChange(oldValue) } }
    
    @MainActor init() {
        state = working
    }
    
    private func didChange(_ oldValue: R.S) {
        guard working != oldValue else { return }
        Task {
            await MainActor.run { [working] in
                state = working
            }
        }
    }
    
    func reduce(_ some: Any) throws -> ReduxAction? {
        if let action = some as? ReduxAction {
            return try reducer.reduce(state: &working, action: action)
        }
        return nil
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
        
        if let action = some as? ReduxAction {
            return try await reducer.middleware(state: working, action: action)
        }
        else if let error = some as? Error {
            return try await reducer.middleware(state: working, error: error)
        }
        return nil
    }
}
