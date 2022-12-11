public actor FiltersReducer: Reducer {
    public typealias S = FiltersState
    public typealias A = FiltersAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload(let find):
            return try await reload(state: &state, find: find)
            
        case .reloaded(let find, let filters, let config):
            reloaded(state: &state, find: find, filters: filters, config: config)
            
        case .toggleTags:
            return try await toggleConfig(state: &state, key: \.tagsHidden)
            
        case .toggleSimple:
            return try await toggleConfig(state: &state, key: \.simpleHidden)
            
        case .saveConfig:
            try await saveConfig(state: &state)
            
        case .update(let filters, let newName):
            return try await update(state: &state, filters: filters, newName: newName)
            
        case .delete(let filters):
            return try await delete(state: &state, filters: filters)
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
