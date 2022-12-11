extension FiltersReducer {
    func delete(state: inout S, filters: Set<Filter>) async throws -> ReduxAction? {
        guard !filters.isEmpty
        else { return nil }
        
        try await rest.tagsDelete(.init(filters.map { $0.title }))
        
        return A.reload()
    }
}
