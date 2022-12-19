import SwiftUI
import API
import Backport

struct AuthScene: View {
    @EnvironmentObject private var auth: AuthStore
    @State private var logIn = false
    @State private var signUp = false

    var body: some View {
        Backport.NavigationStack {
            VStack(spacing: 0) {
                AuthSplash()
                
                HStack(spacing: 16) {
                    Button { logIn = true } label: {
                        Text("Log In").frame(maxWidth: .infinity).frame(height: 32)
                            .foregroundColor(.primary)
                    }
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                    
                    Button { signUp = true } label: {
                        Text("Sign Up").frame(maxWidth: .infinity).frame(height: 32)
                            .foregroundStyle(.background)
                    }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                }
                    .backport.fontWeight(.medium)
                    .buttonBorderShape(.capsule)
                    .scenePadding()
                    .scenePadding(.horizontal)
                    .frame(maxWidth: 500)
                
                Text("We keep your [data safe](https://help.raindrop.io/about#privacy), never sold.\nNo limits. [Starting from $0](https://raindrop.io/pro/buy).")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .scenePadding(.bottom)
            }
                .background(Color.groupedBackground)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("logo-text")
                    }
                    
                    ToolbarItem {
                        Link(destination: URL(string: "https://help.raindrop.io")!) {
                            Label("Help", systemImage: "questionmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title3)
                        }
                            .tint(.secondary)
                    }
                }
                .sheet(isPresented: $logIn) {
                    Backport.NavigationStack(content: AuthLogIn.init)
                        .backport.presentationDetents([.height(360)])
                }
                .sheet(isPresented: $signUp) {
                    Backport.NavigationStack(content: AuthSignUp.init)
                }
        }
            .environmentObject(auth)
    }
}
