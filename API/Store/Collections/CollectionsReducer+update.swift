extension CollectionsReducer {
    func update(state: S, modified: UserCollection, original: UserCollection? = nil) async throws -> ReduxAction? {
        //ignore if no original or nothing modified
        guard let original = original ?? state.user[modified.id], modified != original
        else { return nil }
        
        do {
            return A.updated(
                try await rest.collectionUpdate(
                    original: original,
                    modified: modified
                )
            )
        }
        //reload all when some error happen (maybe local data is outdated)
        catch RestError.forbidden, RestError.invalid(_) {
            return A.reload
        }
        catch {
            throw error
        }
    }
    
    //MARK: - Receive updated/created collection from server
    func updated(state: inout S, collection: UserCollection) -> ReduxAction? {
        state.user[collection.id] = collection
        state.reordered(collection.id)
        state.clean()
        
        state.animation = .init()
        
        return A.saveGroups
    }
}
