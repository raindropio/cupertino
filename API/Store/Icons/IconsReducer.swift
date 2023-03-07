public actor IconsReducer: Reducer {
    public typealias S = IconsState
    public typealias A = IconsAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) throws -> ReduxAction? {
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
        return nil
    }
    
    public func middleware(state: S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload(let filter):
            return await reload(state: state, filter: filter)
            
        default:
            break
        }
        return nil
    }
}
