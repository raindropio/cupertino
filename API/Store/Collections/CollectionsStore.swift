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
    private func collections(_ action: CollectionsAction) async throws {
        switch action {
        case .reload:
            try await reload()
            
        case .create(let collection):
            try await create(draft: collection)
            
        case .update(let collection):
            try await update(changed: collection)
            
        case .delete(let collection):
            try await delete(id: collection.id)
            
        case .changeView(let id, let view):
            if id > 0 {
                try await touch(id: id, keyPath: \UserCollection.view, value: view)
            } else {
                try await touch(id: id, keyPath: \SystemCollection.view, value: view)
            }
        }
    }
}

//MARK: - Auth specific actions
extension CollectionsStore {
    private func auth(_ action: AuthAction) async throws {
        switch action {
        case .logout:
            try await logout()
            
        default:
            break
        }
    }
}
