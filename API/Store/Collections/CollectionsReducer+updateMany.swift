extension CollectionsReducer {
    func updateMany(state: inout S, form: UpdateCollectionsForm) async throws -> ReduxAction? {
        try await rest.collectionUpdateMany(form)
        
        return A.reload
    }
}
