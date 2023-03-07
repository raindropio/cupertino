extension FiltersReducer {
    func update(state: S, tags: Set<String>, newName: String) async throws -> ReduxAction? {
        guard
            !tags.isEmpty,
            !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return nil }
        
        try await rest.tagsUpdate(tags, newName: newName)
        
        return A.reload()
    }
}
