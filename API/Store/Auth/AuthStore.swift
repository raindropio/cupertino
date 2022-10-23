import Foundation

public class AuthStore: ReduxStore {
    public var redux: Redux<AuthState, AuthAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension AuthStore {
    public func react(to action: ReduxAction) async throws {
        if let action = action as? AuthAction {
            try await react(to: action)
        }
    }
}

//MARK: - React to errors
extension AuthStore {
    public func react(to error: Error) async {
        if let error = error as? RestError {
            switch error {
            //If some Rest API response states unauthorized make logout (so other stores can react to it)
            case .unauthorized:
                dispatch(.logout)
                
            default: break
            }
        }
    }
}

//MARK: - Store specific actions
extension AuthStore {
    public func react(to action: AuthAction) async throws {
        switch action {
        case .login(let form):
            try await login(form: form)
            
        case .logout:
            try await logout()
        }
    }
}
