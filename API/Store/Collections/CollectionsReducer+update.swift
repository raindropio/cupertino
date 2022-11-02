extension CollectionsReducer {
    func update(state: inout S, changed: UserCollection) async throws {
        //ignore if no original or nothing changed
        guard let original = state.user[changed.id], changed != original
        else { return }
        
        //update faster
        state.user[original.id] = changed
        
        do {
            let updated = try await rest.collectionUpdate(
                original: original,
                changed: changed
            )
            
            //set updated from server
            state.user[updated.id] = updated
        } catch {
            //revert back
            state.user[original.id] = original
        }
    }
}
