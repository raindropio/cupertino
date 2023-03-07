extension AuthReducer {
    func signup(state: S, body: AuthSignupRequest) async throws -> ReduxAction? {
        try await rest.authSignup(body)
        return A.login(.init(email: body.email, password: body.password))
    }
}
