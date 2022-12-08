public actor RaindropsReducer: Reducer {
    public typealias S = RaindropsState
    public typealias A = RaindropsAction
    
    let rest = Rest()
    
    public init() {}
    
    //MARK: - My actions
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        //Load
        case .load(let find):
            return load(state: &state, find: find)
            
        case .reload(let find):
            return try await reload(state: &state, find: find)
            
        case .reloaded(let find, let items, let total):
            reloaded(state: &state, find: find, items: items, total: total)
            
        case .sort(let find, let by):
            return sort(state: &state, find: find, by: by)
            
        //More
        case .more(let find):
            return more(state: &state, find: find)
            
        case .moreLoad(let find):
            return try await moreLoad(state: &state, find: find)
            
        case .moreLoaded(let find, let page, let items, let total):
            moreLoaded(state: &state, find: find, page: page, items: items, total: total)
            
        //Create
        case .create(let item):
            return A.createMany([item])
            
        //Update
        case .update(let modified):
            return try await update(state: &state, modified: modified)
            
        case .updated(let raindrop):
            updated(state: &state, raindrop: raindrop)
            
        //Delete
        case .delete(let id):
            return A.deleteMany(.some([id]))
            
        //Add web url or file urls
        case .add(let urls, let collection, let completed, let failed):
            return try await add(state: &state, urls: urls, collection: collection, completed: completed, failed: failed)
            
        //Delete Many
        case .deleteMany(let pick):
            return try await deleteMany(state: &state, pick: pick)
            
        case .deletedMany(let pick):
            deletedMany(state: &state, pick: pick)
            
        //Create Many
        case .createMany(let items):
            return try await createMany(state: &state, items: items)
            
        case .createdMany(let items):
            createdMany(state: &state, items: items)
            
        //Update Many
        case .updateMany(let pick, let operation):
            return try await updateMany(state: &state, pick: pick, operation: operation)
            
        case .updatedMany(let pick, let operation):
            updatedMany(state: &state, pick: pick, operation: operation)
            
        //Shorthands
        case .reorder(let id, let to, let order):
            return reorder(state: &state, id: id, to: to, order: order)
            
        case .find(let raindrop):
            try await find(state: &state, raindrop: raindrop)
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
