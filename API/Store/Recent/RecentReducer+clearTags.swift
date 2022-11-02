extension RecentReducer {
    func clearTags(state: inout S) async throws {
        state.tags = .init()
        try await rest.clearRecentTags()
    }
}
