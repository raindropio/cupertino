public actor UserReducer: Reducer {
    public typealias S = UserState
    public typealias A = UserAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) throws -> ReduxAction? {
        switch action {
        case .reloaded(let user):
            reloaded(state: &state, user: user)
            
        default:
            break
        }
        return nil
    }
    
    public func middleware(state: S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload:
            return try await reload(state: state)
            
        default:
            break
        }
        return nil
    }
}

//MARK: - Other
extension UserReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        if let action = action as? AuthAction {
            switch action {
            case .login(_), .apple(_), .jwt(_):
                return A.reload
                
            case .logout:
                logout(state: &state)
                
            case .signup(_):
                break
            }
        }
        
        return nil
    }
}
