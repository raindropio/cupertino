extension RecentReducer {
    func clearSearch(state: S) async throws -> ReduxAction? {
        try await rest.clearRecentSearch()
        return A.reload()
    }
}
