public actor CollectionsReducer: Reducer {
    public typealias S = CollectionsState
    public typealias A = CollectionsAction
    
    var rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload:
            try await reload(state: &state)
            
        case .create(let collection):
            try await create(state: &state, draft: collection)
            
        case .update(let collection):
            try await update(state: &state, changed: collection)
            
        case .delete(let collection):
            try await delete(state: &state, id: collection.id)
            
        case .changeView(let id, let view):
            if id > 0 {
                return try await touch(state: &state, id: id, keyPath: \UserCollection.view, value: view)
            } else {
                try await touch(state: &state, id: id, keyPath: \SystemCollection.view, value: view)
            }
        }
        return nil
    }
    
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        if let action = action as? AuthAction {
            switch action {
            case .logout:
                try await logout(state: &state)
                
            default:
                break
            }
        }
        
        return nil
    }
}
