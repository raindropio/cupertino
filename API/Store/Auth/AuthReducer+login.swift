extension AuthReducer {
    func login(state: S, body: AuthLoginRequest) async throws {
        try await rest.authLogin(body)
    }
}
