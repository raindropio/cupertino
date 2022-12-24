extension CollectionsReducer {
    func delete(state: inout S, id: UserCollection.ID) async throws -> ReduxAction? {
        guard id > 0 else { return nil }
        
        try await rest.collectionDelete(id: id)
        
        return A.deleted(id)
    }
    
    func deleted(state: inout S, id: UserCollection.ID) -> ReduxAction? {
        state.user[id] = nil
        state.clean()
        state.animation = .init()

        return A.saveGroups
    }
}

extension CollectionsReducer {
    //remove group
    func delete(state: inout S, group: CGroup) -> ReduxAction? {
        guard let index = state.groups.firstIndex(of: group)
        else { return nil }
        
        state.groups.remove(at: index)
        state.clean()
        
        return A.saveGroups
    }
}
