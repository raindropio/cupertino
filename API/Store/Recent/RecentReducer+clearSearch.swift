extension RecentReducer {
    func clearSearch(state: inout S) async throws -> ReduxAction? {
        try await rest.clearRecentSearch()
        return A.reload()
    }
}
