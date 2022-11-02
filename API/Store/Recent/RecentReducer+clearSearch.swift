extension RecentReducer {
    func clearSearch(state: inout S) async throws {
        state.search = .init()
        try await rest.clearRecentSearch()
    }
}
