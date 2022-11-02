public actor RecentReducer: Reducer {
    public typealias S = RecentState
    public typealias A = RecentAction
    
    var rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload(let find):
            try await reload(state: &state, find: find)
            
        case .clearSearch:
            try await clearSearch(state: &state)
            
        case .clearTags:
            try await clearTags(state: &state)
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
