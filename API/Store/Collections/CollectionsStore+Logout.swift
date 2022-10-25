extension CollectionsStore {
    func logout() async throws {
        try await mutate { state in
            state.groups = .init()
            state.items = .init()
        }
    }
}
