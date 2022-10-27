import Foundation

public class CollectionsStore: ReduxStore {
    public var redux: Redux<CollectionsState, CollectionsAction>
    var rest = Rest()
    
    @MainActor public init() {
        redux = .init(initialState: .init())
        redux.delegate = self
    }
}

//MARK: - Catch all actions
extension CollectionsStore {
    public func react(to action: ReduxAction) async throws {
        if let action = action as? CollectionsAction {
            try await collections(action)
        } else if let action = action as? AuthAction {
            try await auth(action)
        }
    }
}

//MARK: - Store specific actions
extension CollectionsStore {
    public func collections(_ action: CollectionsAction) async throws {
        switch action {
        case .reload:
            try await reload()
        }
    }
}

//MARK: - Auth specific actions
extension CollectionsStore {
    public func auth(_ action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
