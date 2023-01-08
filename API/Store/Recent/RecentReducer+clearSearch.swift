extension RecentReducer {
    func clearSearch(state: inout S) async throws {
        state.search = .init()
        state.animation = .init()
        try await rest.clearRecentSearch()
    }
}
