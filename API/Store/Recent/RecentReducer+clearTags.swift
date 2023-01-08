extension RecentReducer {
    func clearTags(state: inout S) async throws {
        state.tags = .init()
        state.animation = .init()
        try await rest.clearRecentTags()
    }
}
