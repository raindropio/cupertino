extension FiltersStore {
    func logout() async throws {
        try await mutate { state in
            state.simple = .init()
            state.tags = .init()
            state.created = .init()
        }
    }
}
