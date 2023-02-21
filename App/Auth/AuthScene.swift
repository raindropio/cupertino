import SwiftUI
import API
import UI

struct AuthScene: View {
    @EnvironmentObject private var auth: AuthStore
    @State private var login = false
    @State private var signup = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AuthSplash()
                
                HStack(spacing: 16) {
                    Button { login = true } label: {
                        Text("Log In").frame(maxWidth: .infinity).frame(height: 32)
                            .foregroundColor(.primary)
                    }
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                    
                    Button { signup = true } label: {
                        Text("Sign Up").frame(maxWidth: .infinity).frame(height: 32)
                            .foregroundStyle(.background)
                    }
                        .buttonStyle(.borderedProminent)
                        .tint(.primary)
                }
                    .fontWeight(.medium)
                    .buttonBorderShape(.capsule)
                    .scenePadding()
                    .scenePadding(.horizontal)
                    .frame(maxWidth: 500)
                
                Text("We keep your [data safe](https://help.raindrop.io/about#privacy), never sold. No\u{00a0}limits. Starting from $0.")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .scenePadding(.bottom)
                    .scenePadding(.horizontal)
                    .scenePadding(.horizontal)
            }
                .background(Color.groupedBackground)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("logo-text")
                    }
                    
                    ToolbarItem {
                        SafariLink(destination: URL(string: "https://help.raindrop.io")!) {
                            Label("Help", systemImage: "questionmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .font(.title3)
                        }
                            .tint(.secondary)
                    }
                }
                .sheet(isPresented: $login) {
                    NavigationStack(root: AuthLogIn.init)
                        .presentationDetents([.height(360)])
                }
                .sheet(isPresented: $signup) {
                    NavigationStack(root: AuthSignup.init)
                }
        }
    }
}
