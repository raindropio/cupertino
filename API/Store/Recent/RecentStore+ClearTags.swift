extension RecentStore {
    func clearTags() async throws {
        try await mutate { state in
            state.tags = .init()
        }

        try await rest.clearRecentTags()
    }
}
