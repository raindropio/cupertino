extension CollectionsReducer {
    func delete(state: inout S, id: UserCollection.ID) async throws {
        guard id > 0
        else { return }
        
        let deleted = try await rest.collectionDelete(id: id)
        if !deleted {
            return
        }
        
        state.user[id] = nil
    }
}
