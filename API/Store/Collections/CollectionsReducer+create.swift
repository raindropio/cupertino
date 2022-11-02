extension CollectionsReducer {
    func create(state: inout S, draft: UserCollection) async throws {
        let created = try await rest.collectionCreate(collection: draft)
        state.user[created.id] = created
    }
}
