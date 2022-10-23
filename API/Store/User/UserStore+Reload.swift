extension UserStore {
    func reload() async throws {
        let user = try await rest.userGet()
        try await mutate { state in
            state.me = user
        }
    }
}
