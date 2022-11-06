extension CollectionsReducer {
    //MARK: - 1
    func load(state: inout S) -> ReduxAction? {
        guard state.status != .loading
        else { return nil }
        
        state.status = .loading
        
        return A.reload
    }
    
    //MARK: - 2
    func reload(state: inout S) async throws -> ReduxAction? {
        do {
            async let fetchGroups = rest.collectionGroupsGet()
            async let fetchCollections = rest.collectionsGet()
            
            let (groups, (system, user)) = try await (fetchGroups, fetchCollections)
            return A.reloaded(groups, system, user)
        } catch {
            state.status = .error
            throw error
        }
    }
    
    //MARK: - 3
    func reloaded(state: inout S, groups: [CGroup], system: [SystemCollection], user: [UserCollection]) {
        state.groups = groups
        
        system.forEach {
            var item = $0
            //do not override view
            item.view = state.system[$0.id]?.view ?? item.view
            state.system[$0.id] = item
        }

        user.forEach {
            state.user[$0.id] = $0
        }

        state.status = .idle
    }
}
