extension FiltersReducer {
    func update(state: inout S, filters: Set<Filter>, newName: String) async throws -> ReduxAction? {
        guard
            !filters.isEmpty,
            !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return nil }
        
        try await rest.tagsUpdate(.init(filters.map { $0.title }), newName: newName)
        
        return A.reload()
    }
}
