import SwiftUI
#if os(iOS)
import SignInWithGoogle
#endif
import API

extension AuthContinueWith {
    struct Google: View {
        @Environment(\.isEnabled) private var isEnabled
        var action: (_ action: AuthAction) -> Void
        
        private func googleAuth(_ result: Result<String, Error>) {
            switch result {
            case .success(let accessToken): action(.google(accessToken))
            case .failure(let error): print(error)
            }
        }
        
        var body: some View {
            #if os(iOS)
            SignInWithGoogleButton(.continue, onCompletion: googleAuth)
                .opacity(isEnabled ? 1 : 0.4)
            #endif
        }
    }
}
