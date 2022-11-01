extension CollectionsStore {
    func delete(id: UserCollection.ID) async throws {
        guard id > 0
        else { return }
        
        let deleted = try await rest.collectionDelete(id: id)
        if !deleted {
            return
        }
        
        try await mutate {
            $0.user[id] = nil
        }
    }
}
