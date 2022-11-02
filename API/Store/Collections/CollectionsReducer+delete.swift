extension CollectionsReducer {
    func delete(state: inout S, id: UserCollection.ID) async throws -> ReduxAction? {
        guard id > 0 else { return nil }
        
        try await rest.collectionDelete(id: id)
        
        return A.deleted(id)
    }
    
    func deleted(state: inout S, id: UserCollection.ID) {
        state.user[id] = nil
    }
}
