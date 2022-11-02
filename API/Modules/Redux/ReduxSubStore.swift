import SwiftUI

public actor ReduxSubStore<R: Reducer>: ObservableObject {
    @MainActor var store: Store?
    @MainActor @Published private var s = R.S()
    private var reducer = R()
    
    @MainActor public var state: R.S { s }
    
    public func dispatch(_ action: R.A) async throws {
        try await store?.dispatch(action)
    }
    
    public func dispatch(_ action: ReduxAction) async throws {
        try await store?.dispatch(action)
    }
    
    func reduce(_ some: Any) async throws -> ReduxAction? {
        var mutated = await s
        var next: ReduxAction? = nil
        
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
        
        await MainActor.run { [mutated] in
            if s != mutated {
                s = mutated
            }
        }
        
        return next
    }
}
