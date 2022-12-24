extension CollectionsReducer {
    func create(state: inout S, draft: UserCollection) async throws -> ReduxAction? {
        let new = try await rest.collectionCreate(collection: draft)
        return A.created(new)
    }
}
