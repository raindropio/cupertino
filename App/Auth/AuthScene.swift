import SwiftUI
import API
import Backport

struct AuthScene: View {
    @EnvironmentObject private var auth: AuthStore
    @State private var signIn = false
    @State private var signUp = false

    var body: some View {
        VStack(spacing: 0) {
            AuthSplash()
            
            ControlGroup {
                Button { signIn = true } label: {
                    Text("Sign in").frame(maxWidth: .infinity).frame(height: 32)
                }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)

                Button { signUp = true } label: {
                    Text("Sign up").frame(maxWidth: .infinity).frame(height: 32)
                }
                    .buttonStyle(.borderedProminent)
            }
                .controlGroupStyle(.navigation)
                .backport.fontWeight(.medium)
                .scenePadding()
        }
            .sheet(isPresented: $signIn) {
                Backport.NavigationStack(content: AuthSignIn.init)
                    .backport.presentationDetents([.height(380)])
            }
            .sheet(isPresented: $signUp) {
                Backport.NavigationStack(content: AuthSignUp.init)
            }
            .environmentObject(auth)
    }
}
