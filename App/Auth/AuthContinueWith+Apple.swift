import SwiftUI
import AuthenticationServices
import API

extension AuthContinueWith {
    struct Apple: View {
        var action: (_ action: AuthAction) -> Void
        
        private static func configureApple(_ config: ASAuthorizationAppleIDRequest ) {
            config.requestedOperation = .operationRefresh
            config.requestedScopes = [.fullName, .email]
        }
        
        private func appleAuth(_ result: Result<ASAuthorization, Error>) {
            guard case .success(let authorization) = result else { return }
            action(.apple(authorization))
        }
        
        var body: some View {
            SignInWithAppleButton(
                .continue,
                onRequest: Self.configureApple,
                onCompletion: appleAuth
            )
        }
    }
}
