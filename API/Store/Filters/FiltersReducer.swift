public actor FiltersReducer: Reducer {
    public typealias S = FiltersState
    public typealias A = FiltersAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) throws -> ReduxAction? {
        switch action {
        case .reloaded(let find, let filters):
            reloaded(state: &state, find: find, filters: filters)
            
        case .sort(let by):
            return sort(state: &state, by: by)
            
        default:
            break
        }
        return nil
    }
    
    public func middleware(state: S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload(let find):
            return try await reload(state: state, find: find)
            
        case .update(let tags, let newName):
            return try await update(state: state, tags: tags, newName: newName)
            
        case .delete(let tags):
            return try await delete(state: state, tags: tags)
            
        default:
            break
        }
        return nil
    }
}

//MARK: - Other
extension FiltersReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
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
