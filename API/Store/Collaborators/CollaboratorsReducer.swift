public actor CollaboratorsReducer: Reducer {
    public typealias S = CollaboratorsState
    public typealias A = CollaboratorsAction
    
    let rest = Rest()
    
    public init() {}
    
    public func reduce(state: inout S, action: A) async throws -> ReduxAction? {
        switch action {
        case .load(let collectionId):
            return load(state: &state, collectionId: collectionId)
            
        case .reload(let collectionId):
            return await reload(state: &state, collectionId: collectionId)
            
        case .reloaded(let collectionId, let users):
            reloaded(state: &state, collectionId: collectionId, users: users)
            
        case .reloadFailed(let collectionId, let error):
            try reloadFailed(state: &state, collectionId: collectionId, error: error)
            
        case .invite(let collectionId, let request):
            try await invite(state: &state, collectionId: collectionId, request: request)
            
        case .deleteAll(let collectionId):
            return try await deleteAll(state: &state, collectionId: collectionId)
            
        case .change(let collectionId, let userId, let level):
            return try await change(state: &state, collectionId: collectionId, userId: userId, level: level)
            
        case .changed(let collectionId, let userId, let level):
            changed(state: &state, collectionId: collectionId, userId: userId, level: level)
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
                
            default: break
            }
        }
        
        return nil
    }
}
