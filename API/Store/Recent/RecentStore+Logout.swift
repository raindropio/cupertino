extension RecentStore {
    func logout() async throws {
        try await mutate { state in
            state.search = .init()
            state.tags = .init()
        }
    }
}
