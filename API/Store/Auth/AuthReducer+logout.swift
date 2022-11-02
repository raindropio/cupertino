extension AuthReducer {
    func logout(state: inout S) async throws {
        try await rest.authLogout()
    }
}
