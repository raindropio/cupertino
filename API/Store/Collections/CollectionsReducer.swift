public actor CollectionsReducer: Reducer {
    public typealias S = CollectionsState
    public typealias A = CollectionsAction
    
    var rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        //load
        case .load:
            return load(state: &state)
            
        case .reload:
            return try await reload(state: &state)
            
        case .reloaded(let system, let user):
            reloaded(state: &state, system: system, user: user)
        
        //create
        case .create(let collection):
            return try await create(state: &state, draft: collection)
            
        case .created(let collection):
            created(state: &state, collection: collection)
        
        //update
        case .update(let collection):
            return try await update(state: &state, changed: collection)
            
        case .updated(let collection):
            updated(state: &state, collection: collection)
            
        //delete
        case .delete(let id):
            return try await delete(state: &state, id: id)
            
        case .deleted(let id):
            deleted(state: &state, id: id)
            
        //touch
        case .changeView(let id, let view):
            if id > 0 {
                return try await touch(state: &state, id: id, keyPath: \UserCollection.view, value: view)
            } else {
                touch(state: &state, id: id, keyPath: \SystemCollection.view, value: view)
            }
        }
        return nil
    }
    
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        if let action = action as? AuthAction {
            switch action {
            case .logout:
                logout(state: &state)
                
            default:
                break
            }
        }
        
        return nil
    }
}
