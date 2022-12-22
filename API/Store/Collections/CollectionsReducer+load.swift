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
        }
        catch is CancellationError {
            state.status = .idle
            return nil
        }
        catch {
            state.status = .error
            throw error
        }
    }
    
    //MARK: - 3
    func reloaded(state: inout S, groups: [CGroup], system: [SystemCollection], user: [UserCollection]) {
        state.status = .idle
        state.groups = groups.map {
            var group = $0
            //keep only existings collections
            group.collections = group.collections.filter { id in
                user.contains { $0.id == id }
            }
            return group
        }
        
        //create default groups
        if state.groups.isEmpty {
            state.groups = [.blank]
        }
        
        //update system
        system.forEach {
            var item = $0
            //do not override view
            item.view = state.system[$0.id]?.view ?? item.view
            state.system[$0.id] = item
        }

        //user collections
        state.user = .init()
        user.forEach {
            state.user[$0.id] = $0
        }

        //out of groups fix
        state.user
            .filter { u in
                u.value.parent == nil &&
                !state.groups.contains { $0.collections.contains(u.value.id) }
            }
            .forEach {
                state.groups[state.groups.indices.first!].collections.append($0.key)
            }
    }
}
