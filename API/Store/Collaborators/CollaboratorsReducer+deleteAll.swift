extension CollaboratorsReducer {
    func deleteAll(state: S, collectionId: UserCollection.ID) async throws -> ReduxAction? {
        try await rest.collaboratorsDeleteAll(collectionId)
        return A.load(collectionId)
    }
}
