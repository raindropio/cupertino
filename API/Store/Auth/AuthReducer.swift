public actor AuthReducer: Reducer {
    public typealias S = AuthState
    public typealias A = AuthAction
    
    let rest = Rest()
    
    public init() {
        restore()
    }
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .login(let body):
            try await login(state: &state, body: body)
            
        case .logout:
            try await logout(state: &state)
        }
        return nil
    }
    
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        if let action = action as? UserAction {
            switch action {
            //user successfully reloaded, so persit cookies to keychain
            case .reloaded(_):
                persist()
                
            default:
                break
            }
        }
        
        return nil
    }
    
    public func reduce(state: inout S, error: Error) async throws -> ReduxAction? {
        switch error {
        //If some Rest API response states unauthorized make logout (so other stores can react to it)
        case RestError.unauthorized:
            return A.logout
            
        default: break
        }
        
        return nil
    }
}
