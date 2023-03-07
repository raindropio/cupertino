public actor RecentReducer: Reducer {
    public typealias S = RecentState
    public typealias A = RecentAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) throws -> ReduxAction? {
        switch action {
        case .reloaded(let find, let search, let tags):
            reloaded(state: &state, find: find, search: search, tags: tags)
            
        default:
            break
        }
        return nil
    }
    
    public func middleware(state: S, action: A) async throws -> ReduxAction? {
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
        return nil
    }
}

//MARK: - Other
extension RecentReducer {
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
