public actor CollectionsReducer: Reducer {
    public typealias S = CollectionsState
    public typealias A = CollectionsAction
    
    let rest = Rest()
    
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
            return created(state: &state, collection: collection)
        
        //update
        case .update(let collection, let original):
            return try await update(state: &state, modified: collection, original: original)
            
        case .updated(let collection):
            return updated(state: &state, collection: collection)
            
        case .updateMany(let form):
            return try await updateMany(state: &state, form: form)
            
        //delete
        case .delete(let id):
            return try await delete(state: &state, id: id)
            
        case .deleted(let id):
            deleted(state: &state, id: id)
            
        //groups
        case .saveGroups:
            return try await saveGroups(state: &state)
            
        case .groupsUpdated(let groups):
            groupsUpdated(state: &state, groups: groups)
            
        //helpers
        case .reorder(let id, let parent, let order):
            return reorder(state: &state, id: id, parent: parent, order: order)
            
        case .reorderMany(let by):
            return reorderMany(state: &state, by: by)
            
        case .setView(let id, let view):
            return setView(state: &state, id: id, view: view)
        
        case .toggle(let id):
            return toggle(state: &state, id: id)
            
        case .toggleMany:
            return toggleMany(state: &state)
            
        case .toggleGroup(let group):
            return toggle(state: &state, group: group)
            
        case .renameGroup(let group):
            return rename(state: &state, group: group)
            
        case .deleteGroup(let group):
            return delete(state: &state, group: group)
        }

        return nil
    }
    
    //MARK: - Other actions
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        //Auth
        if let action = action as? AuthAction {
            switch action {
            case .logout:
                logout(state: &state)
                
            default: break
            }
        }
        
        //Raindrops
        if let action = action as? RaindropsAction {
            switch action {
            case .createdMany(_), .updated(_), .deletedMany(_):
                return A.reload
                
            default: break
            }
        }
        
        return nil
    }
}
