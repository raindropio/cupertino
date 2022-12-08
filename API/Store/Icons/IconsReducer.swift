public actor IconsReducer: Reducer {
    public typealias S = IconsState
    public typealias A = IconsAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .load(let filter):
            return load(state: &state, filter: filter)
            
        case .reload(let filter):
            return try await reload(state: &state, filter: filter)
            
        case .reloaded(let filter, let icons):
            reloaded(state: &state, filter: filter, icons: icons)
        }
        return nil
    }
}
