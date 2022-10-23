public struct AuthState: Equatable {
    var status = AuthStatus()
    
    public func isLoading(_ kind: KeyPath<AuthStatus, AuthStatus.Status>) -> Bool {
        switch status[keyPath: kind] {
        case .loading: return true
        default: return false
        }
    }
    
    public func error(_ kind: KeyPath<AuthStatus, AuthStatus.Status>) -> RestError? {
        switch status[keyPath: kind] {
        case .error(let error): return error
        default: return nil
        }
    }
}

extension AuthState {
    public struct AuthStatus: Equatable {
        public var login = Status.idle
        public var logout = Status.idle
        
        public enum Status: Equatable {
            case idle
            case loading
            case error(RestError)
        }
    }
}
