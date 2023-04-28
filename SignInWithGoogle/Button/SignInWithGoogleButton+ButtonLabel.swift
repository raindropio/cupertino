import SwiftUI

extension SignInWithGoogleButton {
    public enum ButtonLabel {
        case signIn
        case `continue`
        case signUp
        case compact
        
        var text: String {
            switch self {
            case .signIn: return "Sign in with Google"
            case .continue: return "Continue with Google"
            case .signUp: return "Sign up with Google"
            case .compact: return "Google"
            }
        }
    }
}
