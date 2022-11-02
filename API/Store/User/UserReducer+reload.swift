extension UserReducer {
    func reload(state: inout S) async throws {
        let user = try await rest.userGet()
        state.me = user
    }
}
