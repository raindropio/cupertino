import SwiftUI
import API
import UI

struct AuthScreen: View {
    @EnvironmentObject private var dispatch: Dispatcher
    @State private var login = false
    @State private var signup = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AuthSplash()
                
                HStack(spacing: 16) {
                    Button { login = true } label: {
                        Text("Log In").frame(maxWidth: .infinity).frame(height: 32)
                            #if canImport(UIKit)
                            .foregroundColor(.primary)
                            #endif
                    }
                        .buttonStyle(.bordered)
                        #if canImport(UIKit)
                        .tint(.secondary)
                        #endif
                    
                    Button { signup = true } label: {
                        Text("Sign Up").frame(maxWidth: .infinity).frame(height: 32)
                            #if canImport(UIKit)
                            .foregroundStyle(.background)
                            #endif
                    }
                        .buttonStyle(.borderedProminent)
                        #if canImport(UIKit)
                        .tint(.primary)
                        #endif
                }
                    .fontWeight(.medium)
                    #if canImport(UIKit)
                    .buttonBorderShape(.capsule)
                    #else
                    .controlSize(.large)
                    #endif
                    .scenePadding()
                    .scenePadding(.horizontal)
                    .frame(maxWidth: 500)
                
                Text("We keep your [data safe](https://help.raindrop.io/about#privacy), never sold. No\u{00a0}limits. Starting from $0.")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .scenePadding(.horizontal)
                    .scenePadding(.horizontal)
            }
                .scenePadding(.vertical)
                .navigationTitle("")
                #if canImport(UIKit)
                .ignoresSafeArea(edges: .top)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("logo-text")
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
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
                        .modifier(AuthSuccess())
                        .presentationDetents([.height(360)])
                }
                .sheet(isPresented: $signup) {
                    NavigationStack(root: AuthSignup.init)
                        .modifier(AuthSuccess())
                }
                .task {
                    try? await dispatch(UserAction.reload)
                }
        }
    }
}
