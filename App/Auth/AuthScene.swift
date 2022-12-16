import SwiftUI
import API
import UI
import Backport
import AuthenticationServices

struct AuthScene: View {
    @EnvironmentObject private var auth: AuthStore
    @State private var signIn = false
    @State private var signUp = false

    var body: some View {
        VStack(spacing: 0) {
            AuthSplash()
            
            ControlGroup {
                Button("Sign in") { signIn = true }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)

                Button("Sign up") { signUp = true }
                    .buttonStyle(.borderedProminent)
                    .backport.fontWeight(.semibold)
            }
                .controlGroupStyle(.navigation)
                .controlSize(.large)
        }
            .sheet(isPresented: $signIn) {
                Backport.NavigationStack(content: AuthSignIn.init)
                    .backport.presentationDetents([.height(260)])
            }
            .sheet(isPresented: $signUp) {
                Backport.NavigationStack(content: AuthSignUp.init)
                    .backport.presentationDetents([.height(330)])
            }
    }
}
