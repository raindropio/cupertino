import Foundation

public actor Store: ObservableObject {
    @MainActor @Published public var raindrops = RaindropsState()
    @MainActor @Published public var users = UsersState()
    @MainActor private var log = LogState()
    
    public init() {
        Task {
            await dispatch(.restore)
        }
    }
    
    public func dispatch(_ action: Action) async {
        do {
            try await dispatch(action, to: \.log)
            try await dispatch(action, to: \.raindrops)
            try await dispatch(action, to: \.users)
        } catch {
            //TODO: Error handling
            print("!Store Error:", error)
        }
    }
    
    private func dispatch<S: State>(_ action: Action, to: ReferenceWritableKeyPath<Store, S>) async throws {
        var newState = self[keyPath: to]
        let nextAction = try await S.reducer(&newState, action)
        
        await MainActor.run { [newState] in
            self[keyPath: to] = newState
        }
        
        if let nextAction {
            await dispatch(nextAction)
        }
    }
}
