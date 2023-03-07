public actor IconsReducer: Reducer {
    public typealias S = IconsState
    public typealias A = IconsAction
    
    let rest = Rest()
    
    public init() {}
}

extension IconsReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        //Icons
        if let action = action as? A {
            switch action {
            case .load(let filter):
                return load(state: &state, filter: filter)
                
            case .reloaded(let filter, let icons):
                reloaded(state: &state, filter: filter, icons: icons)
                
            case .reloadFailed(let filter, let error):
                try reloadFailed(state: &state, filter: filter, error: error)
                
            default:
                break
            }
        }
        
        return nil
    }
    
    public func middleware(state: S, action: ReduxAction) async throws -> ReduxAction? {
        //Icons
        if let action = action as? A {
            switch action {
            case .reload(let filter):
                return await reload(state: state, filter: filter)
                
            default:
                break
            }
        }
        
        return nil
    }
}
