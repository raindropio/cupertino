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
            //my action
            if let action = some as? R.A {
                next = try await reducer.reduce(state: &mutated, action: action)
            }
            //other action
            else if let action = some as? ReduxAction {
                next = try await reducer.reduce(state: &mutated, action: action)
            }
            //error
            else if let error = some as? Error {
                next = try await reducer.reduce(state: &mutated, error: error)
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
}
