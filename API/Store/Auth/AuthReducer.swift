public final class AuthReducer: Reducer {
    public typealias S = AuthState
    public typealias A = AuthAction
    
    let rest = Rest()
    
    @MainActor public init() {
        restore()
    }
}

//MARK: - Reducer
extension AuthReducer {
    public func middleware(state: S, action: ReduxAction) async throws -> ReduxAction? {
        //Auth
        if let action = action as? A {
            switch action {
            case .login(let body):
                try await login(state: state, body: body)
                
            case .signup(let body):
                return try await signup(state: state, body: body)
                
            case .logout:
                try await logout(state: state)
                
            case .apple(let authorization):
                try await apple(state: state, authorization: authorization)
                
            case .jwt(let callbackUrl):
                try await jwt(state: state, callbackUrl: callbackUrl)
            }
        }
        
        //User
        if let action = action as? UserAction {
            switch action {
            case .reloaded(_):
                //user successfully reloaded, so persit cookies to keychain
                persist()
                
            default:
                break
            }
        }
        
        return nil
    }
}

extension AuthReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        return nil
    }
}

//MARK: - Error
extension AuthReducer {
    public func middleware(state: S, error: Error) async throws -> ReduxAction? {
        switch error {
        //If some Rest API response states unauthorized make logout (so other stores can react to it)
        case RestError.unauthorized:
            return A.logout
            
        default: break
        }
        
        return nil
    }
}
