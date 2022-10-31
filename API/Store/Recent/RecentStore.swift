import Foundation

public class RecentStore: ReduxStore {
    public var redux: Redux<RecentState, RecentAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension RecentStore {
    public func react(to action: ReduxAction) async throws {
        if let action = action as? RecentAction {
            try await recent(action)
        } else if let action = action as? AuthAction {
            try await auth(action)
        }
    }
}

//MARK: - Store specific actions
extension RecentStore {
    private func recent(_ action: RecentAction) async throws {
        switch action {
        case .reload(let find):
            try await reload(find: find)
            
        case .clearSearch:
            try await clearSearch()
            
        case .clearTags:
            try await clearTags()
        }
    }
}

//MARK: - Auth specific actions
extension RecentStore {
    private func auth(_ action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
