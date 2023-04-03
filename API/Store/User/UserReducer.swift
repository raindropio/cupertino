public final class UserReducer: Reducer {
    public typealias S = UserState
    public typealias A = UserAction
    
    let rest = Rest()
    
    public init() {}
}

extension UserReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        //User
        if let action = action as? A {
            switch action {
            case .reloaded(let user):
                reloaded(state: &state, user: user)
                
            default:
                break
            }
        }
        
        //Auth
        if let action = action as? AuthAction {
            switch action {
            case .login(_), .apple(_), .jwt(_), .tfa(_, _):
                return A.reload
                
            case .logout:
                logout(state: &state)
                
            case .signup(_):
                break
            }
        }
        
        return nil
    }
    
    public func middleware(state: S, action: ReduxAction) async throws -> ReduxAction? {
        //User
        if let action = action as? A {
            switch action {
            case .reload:
                return try await reload(state: state)
                
            default:
                break
            }
        }
        
        return nil
    }
}
