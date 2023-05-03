public final class RaindropsReducer: Reducer {
    public typealias S = RaindropsState
    public typealias A = RaindropsAction
    
    let rest = Rest()
    
    public init() {}
}

extension RaindropsReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        //Raindrops
        if let action = action as? A {
            switch action {
            //Load
            case .load(let find):
                return load(state: &state, find: find)
                            
            case .reloaded(let find, let items, let total):
                reloaded(state: &state, find: find, items: items, total: total)
                
            case .reloadFailed(let find, let error):
                try reloadFailed(state: &state, find: find, error: error)
                
            case .sort(let find, let by):
                return sort(state: &state, find: find, by: by)
                
            //More
            case .more(let find):
                return more(state: &state, find: find)
                
            case .moreLoaded(let find, let page, let items, let total):
                moreLoaded(state: &state, find: find, page: page, items: items, total: total)
                
            case .moreFailed(let find, let page, let error):
                try moreFailed(state: &state, find: find, page: page, error: error)
                
            //Create
            case .create(let item):
                return A.createMany([item])
                
            //Update
            case .updated(let raindrop):
                updated(state: &state, raindrop: raindrop)
                
            //Delete
            case .delete(let id):
                return A.deleteMany(.some([id]))
                
            case .deletedMany(let pick):
                deletedMany(state: &state, pick: pick)
                
            //Create Many
            case .createdMany(let items):
                createdMany(state: &state, items: items)
                
            //Update Many
            case .updatedMany(let pick, let operation):
                updatedMany(state: &state, pick: pick, operation: operation)
                
            //Item
            case .loaded(let raindrop):
                loaded(state: &state, raindrop: raindrop)
                
            case .suggested(let url, let suggestions):
                suggested(state: &state, url: url, suggestions: suggestions)
                
            //Shorthands
            case .reorder(let id, let to, let order):
                return reorder(state: &state, id: id, to: to, order: order)
                
            default:
                break
            }
        }
        
        //Collection
        if let action = action as? CollectionsAction {
            switch action {
            case .deleteMany(let ids, _):
                deletedCollections(state: &state, ids: ids)
                
            default:
                break
            }
        }
        
        //Auth
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
    
    public func middleware(state: S, action: ReduxAction) async throws -> ReduxAction? {
        //Raindrops
        if let action = action as? A {
            switch action {
            //Load
            case .reload(let find):
                return await reload(state: state, find: find)
                
            //More
            case .moreLoad(let find):
                return await moreLoad(state: state, find: find)
                
            //Update
            case .update(let modified):
                return try await update(state: state, modified: modified)
                
            //Add web url or file urls
            case .add(let urls, let collection, let completed, let failed):
                return try await add(state: state, urls: urls, collection: collection, completed: completed, failed: failed)
                
            //Delete Many
            case .deleteMany(let pick):
                return try await deleteMany(state: state, pick: pick)
                
            //Create Many
            case .createMany(let items):
                return try await createMany(state: state, items: items)
                
            //Update Many
            case .updateMany(let pick, let operation):
                return try await updateMany(state: state, pick: pick, operation: operation)
                
            //Item
            case .lookup(let url):
                return await lookup(state: state, url: url)
                
            case .suggest(let raindrop):
                return await suggest(state: state, raindrop: raindrop)
                
            case .enrich(let raindrop):
                try await enrich(state: state, raindrop: raindrop)
                
            default:
                break
            }
        }
        
        return nil
    }
}
