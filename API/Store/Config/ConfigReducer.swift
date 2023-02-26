public actor ConfigReducer: Reducer {
    public typealias S = ConfigState
    public typealias A = ConfigAction
    
    let rest = Rest()
    
    public init() {}
    
    //MARK: - My actions
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
            //config
        case .load:
            return await load(state: &state)
            
        case .reloaded(let config):
            reloaded(state: &state, config: config)
            
        case .updateRaindrops(let raindrops):
            return update(state: &state, raindrops: raindrops)
            
        case .save:
            try await save(state: &state)
            return nil
        }
        return nil
    }
    
    //MARK: - Other actions
    public func reduce(state: inout S, action: ReduxAction) async throws -> ReduxAction? {
        //Auth
        if let action = action as? AuthAction {
            switch action {
            case .logout:
                logout(state: &state)
                
            default:
                break
            }
        }
        
        //User
        if let action = action as? UserAction {
            switch action {
            case .reloaded(_):
                return A.load
                
            default:
                break
            }
        }
        
        return nil
    }
}
