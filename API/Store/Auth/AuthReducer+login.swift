extension AuthReducer {
    func login(state: inout S, form: AuthLoginForm) async throws {
        try await rest.authLogin(form: form)
    }
}
