extension AuthReducer {
    func login(state: inout S, body: AuthLoginRequest) async throws {
        try await rest.authLogin(body)
    }
}
