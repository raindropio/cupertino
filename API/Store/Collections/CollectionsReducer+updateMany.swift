extension CollectionsReducer {
    func updateMany(state: inout S, body: UpdateCollectionsRequest) async throws -> ReduxAction? {
        try await rest.collectionUpdateMany(body)
        
        return A.reload
    }
}
