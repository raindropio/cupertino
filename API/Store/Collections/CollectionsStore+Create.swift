extension CollectionsStore {
    func create(draft: UserCollection) async throws {
        let created = try await rest.collectionCreate(collection: draft)
        try await mutate {
            $0.user[created.id] = created
        }
    }
}
