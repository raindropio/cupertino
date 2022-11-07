public actor AuthReducer: Reducer {
    public typealias S = AuthState
    public typealias A = AuthAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
            case .login(let form):
                try await login(state: &state, form: form)
                
            case .logout:
                try await logout(state: &state)
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
