extension CollectionsReducer {
    func update(state: inout S, changed: UserCollection, fast: Bool) async throws -> ReduxAction? {
        //ignore if no original or nothing changed
        guard let original = state.user[changed.id], changed != original
        else { return nil }
        
        //update in place without waiting updated event
        if fast {
            state.user[changed.id] = changed
        }
        
        let updated = try await rest.collectionUpdate(
            original: original,
            changed: changed
        )
        
        if !fast {
            return A.updated(updated)
        }
        return nil
    }
    
    func updated(state: inout S, collection: UserCollection) {
        state.user[collection.id] = collection
    }
}
