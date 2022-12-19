import AuthenticationServices

extension AuthReducer {
    func apple(state: inout S, authorization: ASAuthorization) async throws {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential
        else { return }
        
        try await rest.authApple(credentials: credentials)
    }
}
