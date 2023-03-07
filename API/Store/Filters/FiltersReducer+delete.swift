extension FiltersReducer {
    func delete(state: S, tags: Set<String>) async throws -> ReduxAction? {
        guard !tags.isEmpty
        else { return nil }
        
        try await rest.tagsDelete(tags)
        
        return A.reload()
    }
}
