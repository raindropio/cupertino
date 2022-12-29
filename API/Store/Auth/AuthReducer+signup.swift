extension AuthReducer {
    func signup(state: inout S, body: AuthSignupRequest) async throws -> ReduxAction? {
        try await rest.authSignup(body)
        return A.login(.init(email: body.email, password: body.password))
    }
}
