extension CollectionsReducer {
    func update(state: inout S, changed: UserCollection, original: UserCollection? = nil) async throws -> ReduxAction? {
        //ignore if no original or nothing changed
        guard let original = original ?? state.user[changed.id], changed != original
        else { return nil }
        
        let updated = try await rest.collectionUpdate(
            original: original,
            changed: changed
        )
        
        return A.updated(updated)
    }
    
    func updated(state: inout S, collection: UserCollection) {
        state.user[collection.id] = collection
    }
}
