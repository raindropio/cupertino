extension UserStore {
    func logout() async throws {
        try await mutate { state in
            state.me = nil
        }
    }
}
