import AuthenticationServices

extension AuthReducer {
    func google(state: S, accessToken: String) async throws {
        try await rest.authGoogle(accessToken: accessToken)
    }
}
