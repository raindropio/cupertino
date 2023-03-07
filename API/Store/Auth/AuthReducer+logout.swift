extension AuthReducer {
    func logout(state: S) async throws {
        try await rest.authLogout()
    }
}
