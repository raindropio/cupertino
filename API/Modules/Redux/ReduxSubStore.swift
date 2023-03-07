import SwiftUI

public actor ReduxSubStore<R: Reducer>: ObservableObject {
    @MainActor @Published private var s = R.S()
    private var reducer = R()
    
    @MainActor public var state: R.S { s }
    
    func reduce(_ some: Any) async throws -> ReduxAction? {
        var mutated = await s
        var next: ReduxAction? = nil
        var nextError: Error? = nil
        
        do {
            if let action = some as? ReduxAction {
                next = try await reducer.reduce(state: &mutated, action: action)
            }
        } catch {
            nextError = error
        }
        
        if (await s) != mutated {
            await MainActor.run { [mutated] in
                s = mutated
            }
        }
        
        if let nextError {
            throw nextError
        }
        return next
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
        
        let state = await s
        var next: ReduxAction? = nil
        var nextError: Error? = nil
        
        do {
            //action
            if let action = some as? ReduxAction {
                next = try await reducer.middleware(state: state, action: action)
            }
            //error
            else if let error = some as? Error {
                next = try await reducer.middleware(state: state, error: error)
            }
        } catch {
            nextError = error
        }
        
        if let nextError {
            throw nextError
        }
        return next
    }
}
