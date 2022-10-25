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
        switch action {
        case is CollectionsAction:
            try await react(to: action as! CollectionsAction)
            
        case is AuthAction:
            try await react(to: action as! AuthAction)
            
        default: break
        }
    }
}

//MARK: - Store specific actions
extension CollectionsStore {
    public func react(to action: CollectionsAction) async throws {
        switch action {
        case .reload:
            try await reload()
        }
    }
}

//MARK: - Auth specific actions
extension CollectionsStore {
    public func react(to action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
