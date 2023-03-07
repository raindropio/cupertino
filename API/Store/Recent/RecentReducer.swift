public actor RecentReducer: Reducer {
    public typealias S = RecentState
    public typealias A = RecentAction
    
    let rest = Rest()
    
    public init() {}
}

extension RecentReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        //Recent
        if let action = action as? A {
            switch action {
            case .reloaded(let find, let search, let tags):
                reloaded(state: &state, find: find, search: search, tags: tags)
                
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
        //Recent
        if let action = action as? A {
            switch action {
            case .reload(let find):
                return try await reload(state: state, find: find)
                
            case .clearSearch:
                return try await clearSearch(state: state)
                
            case .clearTags:
                return try await clearTags(state: state)
                
            default:
                break
            }
        }
        
        return nil
    }
}
