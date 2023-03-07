public actor ConfigReducer: Reducer {
    public typealias S = ConfigState
    public typealias A = ConfigAction
    
    let rest = Rest()
    
    public init() {}
}

extension ConfigReducer {
    public func reduce(state: inout S, action: ReduxAction) throws -> ReduxAction? {
        //Config
        if let action = action as? A {
            switch action {
            case .reloaded(let config):
                reloaded(state: &state, config: config)
                
            case .updateRaindrops(let raindrops):
                return update(state: &state, raindrops: raindrops)
                
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
    
    public func middleware(state: S, action: ReduxAction) async throws -> ReduxAction? {
        //Config
        if let action = action as? A {
            switch action {
            case .load:
                return await load(state: state)
                
            case .save:
                try await save(state: state)
                
            default:
                break
            }
        }
        
        return nil
    }
}
