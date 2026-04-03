import SwiftUI

extension SignInWithGoogleButton {
    public enum ButtonLabel {
        case signIn
        case `continue`
        case signUp
        case compact
        
        var text: String {
            switch self {
            case .signIn: return String(localized: "Sign in with Google", bundle: .module)
            case .continue: return String(localized: "Continue with Google", bundle: .module)
            case .signUp: return String(localized: "Sign up with Google", bundle: .module)
            case .compact: return "Google"
            }
        }
    }
}
