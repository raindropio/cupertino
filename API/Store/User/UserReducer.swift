public actor UserReducer: Reducer {
    public typealias S = UserState
    public typealias A = UserAction
    
    var rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload:
            try await reload(state: &state)
        }
        return nil
    }
    
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        if let action = action as? AuthAction {
            switch action {
            case .login(_):
                try await reload(state: &state)
                
            case .logout:
                try await logout(state: &state)
            }
        }
        
        return nil
    }
}
