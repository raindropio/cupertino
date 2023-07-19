import SwiftUI
import GoogleSignIn

public struct SignInWithGoogleButton {
    var label: ButtonLabel
    var onCompletion: (Result<String, Error>) -> Void
    
    public init(_ label: ButtonLabel = .signIn, onCompletion: @escaping (Result<String, Error>) -> Void) {
        self.label = label
        self.onCompletion = onCompletion
    }
}

extension SignInWithGoogleButton {
    private func onPress() {
        guard let vc = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        GIDSignIn.sharedInstance.signOut()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
            guard let result else {
                if let error {
                    onCompletion(.failure(error))
                }
                return
            }
            
            result.user.refreshTokensIfNeeded { user, error in
                if let error {
                    onCompletion(.failure(error))
                } else if let token = user?.accessToken {
                    onCompletion(.success(token.tokenString))
                }
            }
        }
    }
}

extension SignInWithGoogleButton: View {
    public var body: some View {
        Button(action: onPress) {
            HStack(spacing: 5) {
                Image("google-symbol", bundle: .module)
                    .foregroundColor(.red)
                
                Text(label.text)
                    .foregroundColor(.primary)
            }
                .minimumScaleFactor(0.7)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            .onOpenURL {
                GIDSignIn.sharedInstance.handle($0)
            }
    }
}
