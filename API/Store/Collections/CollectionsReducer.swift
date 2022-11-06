public actor CollectionsReducer: Reducer {
    public typealias S = CollectionsState
    public typealias A = CollectionsAction
    
    var rest = Rest()
    
    public init() {}
    
    //MARK: - My actions
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        //load
        case .load:
            return load(state: &state)
            
        case .reload:
            return try await reload(state: &state)
            
        case .reloaded(let groups, let system, let user):
            reloaded(state: &state, groups: groups, system: system, user: user)
        
        //create
        case .create(let collection):
            return try await create(state: &state, draft: collection)
            
        case .created(let collection):
            created(state: &state, collection: collection)
        
        //update
        case .update(let collection, let original):
            return try await update(state: &state, changed: collection, original: original)
            
        case .updated(let collection):
            updated(state: &state, collection: collection)
            
        //delete
        case .delete(let id):
            return try await delete(state: &state, id: id)
            
        case .deleted(let id):
            deleted(state: &state, id: id)
            
        //helpers
        case .reorder(let id, let parent, let order):
            return reorder(state: &state, id: id, parent: parent, order: order)
            
        case .setView(let id, let view):
            return setView(state: &state, id: id, view: view)
        
        case .toggle(let id):
            return toggle(state: &state, id: id)
        }

        return nil
    }
    
    //MARK: - Other actions
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
