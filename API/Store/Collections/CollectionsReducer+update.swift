extension CollectionsReducer {
    func update(state: inout S, modified: UserCollection, original: UserCollection? = nil) async throws -> ReduxAction? {
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
    
    //MARK: - Receive updated collection from server
    func updated(state: inout S, collection: UserCollection) -> ReduxAction? {
        let original = state.user[collection.id]
        state.user[collection.id] = collection
        
        //reorder or change of a parent happen
        if (
            original?.parent != collection.parent ||
            original?.sort != collection.sort
        ) {
            //become nested
            if collection.parent != nil {
                //reorder siblings (set correct `sort` value)
                state.fixSiblings(of: collection)
                
                //remove from groups (server should do this by itself, just to make sure)
                state.removeFromGroups(collection.id)
                
                return A.saveGroups
            }
            
            //become root
            if collection.parent == nil {
                //originally belonged to group
                var groupIndex = 0
                if let original, let inGroup = state.location(of: original) {
                    groupIndex = state.groups.firstIndex(of: inGroup) ?? 0
                }
                
                //remove from groups (just to prevent duplicates)
                state.removeFromGroups(collection.id)
                
                //insert to specific position inside group
                state.groups[groupIndex].collections
                    .insert(
                        collection.id,
                        at: max(0, min(collection.sort, state.groups[groupIndex].collections.count))
                    )
                
                return A.saveGroups
            }
        }
        
        return nil
    }
}
