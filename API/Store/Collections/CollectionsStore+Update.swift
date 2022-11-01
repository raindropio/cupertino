extension CollectionsStore {
    func update(changed: UserCollection) async throws {
        //ignore if no original or nothing changed
        guard let original = await state.user[changed.id], changed != original
        else { return }
        
        //update faster
        try await mutate {
            $0.user[original.id] = changed
        }
        
        do {
            let updated = try await rest.collectionUpdate(
                original: original,
                changed: changed
            )
            
            //set updated from server
            try await mutate {
                $0.user[updated.id] = updated
            }
        } catch {
            //revert back
            try await mutate {
                $0.user[original.id] = original
            }
        }
    }
}
