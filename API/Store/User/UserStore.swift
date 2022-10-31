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
        if let action = action as? UserAction {
            try await user(action)
        } else if let action = action as? AuthAction {
            try await auth(action)
        }
    }
}

//MARK: - Store specific actions
extension UserStore {
    private func user(_ action: UserAction) async throws {
        switch action {
        case .reload:
            try await reload()
        }
    }
}

//MARK: - Auth specific actions
extension UserStore {
    private func auth(_ action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
