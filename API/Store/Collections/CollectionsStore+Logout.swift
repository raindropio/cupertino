extension CollectionsStore {
    func logout() async throws {
        try await mutate { state in
            state.user = .init()
        }
    }
}
