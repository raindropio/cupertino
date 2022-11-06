extension CollectionsReducer {
    func delete(state: inout S, id: UserCollection.ID) async throws -> ReduxAction? {
        guard id > 0 else { return nil }
        
        try await rest.collectionDelete(id: id)
        
        return A.deleted(id)
    }
    
    func deleted(state: inout S, id: UserCollection.ID) {
        //remove collection item
        state.user[id] = nil
        
        //remove from groups
        state.groups = state.groups.map {
            var group = $0
            group.collections = group.collections.filter { $0 != id }
            return group
        }
    }
}
