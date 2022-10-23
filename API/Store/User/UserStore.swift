import Foundation

public class UserStore: ReduxStore {
    public var redux: Redux<UserState, UserAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension UserStore {
    public func react(to action: ReduxAction) async throws {
        switch action {
        case is UserAction:
            try await react(to: action as! UserAction)
            
        case is AuthAction:
            try await react(to: action as! AuthAction)
            
        default: break
        }
    }
}

//MARK: - Store specific actions
extension UserStore {
    public func react(to action: UserAction) async throws {
        switch action {
        case .reload:
            try await reload()
        }
    }
}

//MARK: - Auth specific actions
extension UserStore {
    public func react(to action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
