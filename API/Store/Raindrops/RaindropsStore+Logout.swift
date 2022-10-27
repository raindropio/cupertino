extension RaindropsStore {
    func logout() async throws {
        try await mutate { state in
            state.items = .init()
            state.segments = .init()
        }
    }
}
