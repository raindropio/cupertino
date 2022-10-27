extension RecentStore {
    func clearSearch() async throws {
        try await mutate { state in
            state.search = .init()
        }

        try await rest.clearRecentSearch()
    }
}
