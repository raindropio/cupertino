extension CollectionsReducer {
    func create(state: inout S, draft: UserCollection) async throws -> ReduxAction? {
        let new = try await rest.collectionCreate(collection: draft)
        return A.created(new)
    }
    
    func created(state: inout S, collection: UserCollection) -> ReduxAction? {
        state.user[collection.id] = collection
        
        //nested
        if collection.parent != nil {
            state.fixSiblings(of: collection)
        }
        //root
        else {
            state.groups[0].collections
                .insert(
                    collection.id,
                    at: max(0, min(collection.sort, state.groups[0].collections.count))
                )
            
            return A.saveGroups
        }
        
        return nil
    }
}
