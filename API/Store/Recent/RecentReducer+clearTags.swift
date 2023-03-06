extension RecentReducer {
    func clearTags(state: inout S) async throws -> ReduxAction? {
        try await rest.clearRecentTags()
        return A.reload()
    }
}
