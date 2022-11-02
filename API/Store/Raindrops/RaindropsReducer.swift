public actor RaindropsReducer: Reducer {
    public typealias S = RaindropsState
    public typealias A = RaindropsAction
    
    var rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .reload(let find):
            try await reload(state: &state, find: find)
            
        case .loadMore(let find):
            try await loadMore(state: &state, find: find)
            
        case .sort(let find, let by):
            return try await sort(state: &state, find: find, by: by)
            
        case .create(let item):
            return A.createMany([item])
            
        case .createMany(let items):
            try await createMany(state: &state, items: items)
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
