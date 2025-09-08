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
                            #if os(iOS)
                            .foregroundColor(.primary)
                            #endif
                    }
                        .buttonStyle(.bordered)
                        #if os(iOS)
                        .tint(.secondary)
                        #endif
                    
                    Button { signup = true } label: {
                        Text("Sign Up").frame(maxWidth: .infinity).frame(height: 32)
                            #if os(iOS)
                            .foregroundStyle(.background)
                            #endif
                    }
                        .buttonStyle(.borderedProminent)
                        #if os(iOS)
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
                
                Text("We keep your [data safe](https://help.raindrop.io/about#privacy), never sold.\nNo\u{00a0}limits. Starting from $0.")
                    .foregroundStyle(.secondary)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .scenePadding(.horizontal)
            }
                .scenePadding(.vertical)
                .ignoresSafeArea(edges: .top)
                .navigationTitle("")
                .toolbarBackground(.clear, for: .automatic)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("logo-text")
                    }
                    
                    ToolbarItem {
                        SafariLink(destination: URL(string: "https://help.raindrop.io/about")!) {
                            Image(systemName: "questionmark.circle")
                                .imageScale(.large)
                        }
                            #if os(iOS)
                            .tint(.secondary)
                            #endif
                    }
                }
                .sheet(isPresented: $login) {
                    NavigationStack(root: AuthLogIn.init)
                        .modifier(AuthTFA())
                        .modifier(AuthSuccess())
                        .frame(idealWidth: 360)
                }
                .sheet(isPresented: $signup) {
                    NavigationStack(root: AuthSignup.init)
                        .modifier(AuthTFA())
                        .modifier(AuthSuccess())
                        .frame(idealWidth: 360)
                }
                .task(priority: .background) {
                    try? await dispatch(UserAction.reload)
                }
        }
    }
}
