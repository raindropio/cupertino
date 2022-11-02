extension CollectionsReducer {
    func create(state: inout S, draft: UserCollection) async throws -> ReduxAction? {
        let new = try await rest.collectionCreate(collection: draft)
        return A.created(new)
    }
    
    func created(state: inout S, collection: UserCollection) {
        state.user[collection.id] = collection
    }
}
