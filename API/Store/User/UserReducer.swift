public actor UserReducer: Reducer {
    public typealias S = UserState
    public typealias A = UserAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload:
            return try await reload(state: &state)
            
        case .reloaded(let user):
            reloaded(state: &state, user: user)
        }
        return nil
    }
    
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        if let action = action as? AuthAction {
            switch action {
            case .login(_), .apple(_), .jwt(_):
                return try await reload(state: &state)
                
            case .logout:
                logout(state: &state)
                
            case .signup(_):
                break
            }
        }
        
        return nil
    }
}
