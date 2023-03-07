extension CollectionsReducer {
    //MARK: - 1
    func load(state: inout S) -> ReduxAction? {
        guard state.status != .loading
        else { return nil }
        
        state.status = .loading
        
        return A.reload
    }
    
    //MARK: - 2
    func reload(state: S) async -> ReduxAction? {
        do {
            async let fetchGroups = rest.collectionGroupsGet()
            async let fetchCollections = rest.collectionsGet()
            
            let (groups, (system, user)) = try await (fetchGroups, fetchCollections)
            return A.reloaded(groups, system, user)
        }
        catch {
            return A.reloadFailed(error)
        }
    }
    
    //MARK: - 3
    func reloadFailed(state: inout S, error: Error) throws {
        switch error {
        case is CancellationError:
            state.status = .idle
        default:
            state.status = .error
            throw error
        }
    }
    
    //MARK: - 4
    func reloaded(state: inout S, groups: [CGroup], system: [SystemCollection], user: [UserCollection]) {
        state.status = .idle
        state.groups = groups
        
        //update system
        system.forEach {
            var item = $0
            //do not override view
            item.view = state.system[$0.id]?.view ?? item.view
            state.system[$0.id] = item
        }

        //user collections
        var newUser: [UserCollection.ID: UserCollection] = [:]
        user.forEach {
            newUser[$0.id] = $0
        }
        if state.user != newUser {
            state.animation = .init()
            state.user = newUser
        }

        state.clean()
    }
}
