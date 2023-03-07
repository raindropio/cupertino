extension RecentReducer {
    func clearTags(state: S) async throws -> ReduxAction? {
        try await rest.clearRecentTags()
        return A.reload()
    }
}
