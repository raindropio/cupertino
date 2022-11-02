public actor FiltersReducer: Reducer {
    public typealias S = FiltersState
    public typealias A = FiltersAction
    
    var rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload(let find):
            try await reload(state: &state, find: find)
        }
        return nil
    }
    
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        if let action = action as? AuthAction {
            switch action {
            case .logout:
                try await logout(state: &state)
                
            default:
                break
            }
        }
        
        return nil
    }
}
