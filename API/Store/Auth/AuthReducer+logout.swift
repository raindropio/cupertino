extension AuthReducer {
    func logout(state: inout S) async throws {
        _ = try await rest.authLogout()
    }
}
